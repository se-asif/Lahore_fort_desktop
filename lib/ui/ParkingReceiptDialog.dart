import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../data_models/visiting_data_list/visiting_data_list.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../providers/LoginProvider.dart';
import '../utils/Constants.dart';
import 'package:provider/provider.dart';

import '../utils/SystemIPHelper.dart';

class ParkingReceiptDialog {
  static final GlobalKey _globalKey = GlobalKey();

  static bool _isPrinting =false;

  static void show(BuildContext context, List<VisitingDataList>? visitorDataList) async {
    if (visitorDataList == null || visitorDataList.isEmpty) return;

    print('🎫 Starting ticket generation for ${visitorDataList.length} visitor data entries');

    // Access provider BEFORE any await calls
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Ensure user is loaded from SharedPreferences
    if (loginProvider.user == null) {
      await loginProvider.loadUser();
    }

    // FIXED: Use firstName and lastName to get the actual user name
    final userFirstName = loginProvider.user?.firstName ?? '';
    final userLastName = loginProvider.user?.lastName ?? '';
    final currentUserName = '$userFirstName $userLastName'.trim();

    // Get parking lot name from provider
    final currentTicketingPoint = loginProvider.user?.parkingLotName;

    // Final values to use (prioritize provider over data)
    final userName = currentUserName.isNotEmpty ? currentUserName : visitorDataList.first.userName;
    final ticketingPoint = currentTicketingPoint ?? visitorDataList.first.ticketingPoint;

    print('DEBUG - User Name (from provider firstName+lastName): $userName');
    print('DEBUG - Ticketing Point (from provider): $ticketingPoint');

    // ✅ FIX: Use static IP instead of fetching from system
    const String systemIP = "192.168.1.112";
    print('DEBUG - System IP (static): $systemIP');

    // ✅ FIX: Create ticketList BEFORE showing dialog to ensure all tickets are generated
    final List<Map<String, dynamic>> ticketList = [];

    for (final data in visitorDataList) {
      print('🔍 Processing visitor data - Total Persons: ${data.totalPersons}');
      print('🔍 TypeWiseData: ${data.typeWiseData}');

      final Map<int, List<Map<String, dynamic>>> groupedByVisitorType = {};

      for (final typeData in data.typeWiseData ?? []) {
        final rawVisitorTypeId = typeData['visitorTypeId'];
        final visitorTypeId = rawVisitorTypeId is int
            ? rawVisitorTypeId
            : int.tryParse(rawVisitorTypeId.toString()) ?? -1;

        groupedByVisitorType.putIfAbsent(visitorTypeId, () => []).add(typeData);
        print('🔍 Added to group $visitorTypeId: ${typeData['serviceName']} with count ${typeData['count']}');
      }

      print('🔍 Total visitor type groups: ${groupedByVisitorType.length}');

      for (final entry in groupedByVisitorType.entries) {
        final visitorTypeId = entry.key;
        final services = entry.value;

        print('🔍 Processing visitor type $visitorTypeId with ${services.length} services');

        final maxCount = services.map((e) => e['count'] as int? ?? 0).reduce((a, b) => a > b ? a : b);
        print('🔍 Max count for this group: $maxCount');

        for (int i = 0; i < maxCount; i++) {
          print('🔍 Creating ticket ${i + 1}/$maxCount');

          final List<Map<String, dynamic>> servicesForThisTicket = [];

          for (final service in services) {
            final count = service['count'] as int? ?? 0;
            print('🔍   Checking service ${service['serviceName']} - count: $count, i: $i');
            if (i < count) {
              servicesForThisTicket.add({
                'serviceName': service['serviceName'],
                'routine_charges': double.tryParse(service['routine_charges'].toString()) ?? 0.0,
              });
              print('🔍   ✅ Added service ${service['serviceName']} to ticket');
            } else {
              print('🔍   ❌ Skipped service ${service['serviceName']} (i >= count)');
            }
          }

          if (servicesForThisTicket.isNotEmpty) {
            String? transactionId;
            for (final service in services) {
              final tranIds = service['transection_unique_ids'];
              print('🔍   Checking transection_unique_ids: $tranIds (type: ${tranIds.runtimeType})');
              if (tranIds is List && i < tranIds.length) {
                transactionId = tranIds[i].toString();
                print('🔍   ✅ Found transaction ID at index $i: $transactionId');
                break;
              } else {
                print('🔍   ❌ No transaction ID found at index $i');
              }
            }

            final baseTransactionId = transactionId ?? '${DateTime.now().millisecondsSinceEpoch}-$i';
            print('🔍   Using transaction ID: $baseTransactionId');

            // Debug print for each ticket
            print('🎫 Creating ticket #${ticketList.length + 1} - ID: $baseTransactionId');

            ticketList.add({
              'transection_unique_id': baseTransactionId,
              'qr_code_data': '${systemIP}_$baseTransactionId',
              'services': servicesForThisTicket,
              'visitorTypeId': visitorTypeId,
              'data': data,
              'currentUserName': userName ?? 'Unknown User',
              'currentTicketingPoint': ticketingPoint ?? 'Unknown Point',
            });
          } else {
            print('🔍   ⚠️ No services for this ticket, skipping');
          }
        }
      }
    }

    print('✅ Total tickets created: ${ticketList.length}');

    // Now show dialog with pre-generated ticketList
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 0.8.sh),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          constraints: BoxConstraints(maxWidth: 100.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: ticketList.map((ticket) {
                              final services = ticket['services'] as List;
                              final data = ticket['data'] as VisitingDataList;
                              final totalAmount = services.fold<double>(0.0, (sum, item) {
                                final charge = item['routine_charges'];
                                if (charge is int) return sum + charge.toDouble();
                                if (charge is double) return sum + charge;
                                return sum;
                              });

                              final userName = ticket['currentUserName'];
                              final ticketingPoint = ticket['currentTicketingPoint'];

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/images/lahore_fort_logo.png',
                                          height: 110,
                                          width: 110,
                                          fit: BoxFit.cover,
                                        ),
                                        const Text(
                                          Constants.lahoreZoo,
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                  Text("Entry Ticket: ${ticket['transection_unique_id']}", style: TextStyle(fontSize: 18)),
                                  const SizedBox(height: 3),
                                  Text("Bill No: ${data.billNo}", style: TextStyle(fontSize: 18)),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Services", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      Text("Amount", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  ...services.map((typeData) => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(typeData['serviceName'].toString(), style: TextStyle(fontSize: 18)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          (typeData['routine_charges'] is num ? (typeData['routine_charges'] as num).toDouble() : 0.0).toStringAsFixed(2),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  )),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text("Total Paid:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 20),
                                        child: Text(totalAmount.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(ticketingPoint ?? "", style: const TextStyle(fontSize: 16)),
                                  Text("Date: ${data.date}", style: const TextStyle(fontSize: 18)),
                                  Text(userName ?? "", style: const TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontSize: 18)),
                                  const SizedBox(height: 10),
                                  const Text("Thank you", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const Text("Valid for Same Day Only", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 3),
                                  const Text("Timing 07am to 07pm", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: QrImageView(
                                      data: ticket['qr_code_data'],
                                      version: QrVersions.auto,
                                      size: 110.0,
                                    ),
                                  ),
                                  const Divider(thickness: 2),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_isPrinting) return;

                        _isPrinting = true;

                        try {
                          await _createPdfFromData(ticketList);
                        } catch (e) {
                          debugPrint("Print error: $e");
                        } finally {
                          _isPrinting = false;
                        }

                        Navigator.pop(dialogContext);
                      },

                      icon: const Icon(Icons.print),
                      label: const Text("Print"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> _createPdfFromData(List<dynamic> ticketList) async {
    print('📄 Creating PDF for ${ticketList.length} tickets');
    final pdf = pw.Document();
    final logoImage = await _loadImage('assets/images/lahore_fort_logo.png');

    int ticketNumber = 0;
    for (final ticket in ticketList) {
      ticketNumber++;
      print('📄 Adding ticket $ticketNumber/${ticketList.length} to PDF');

      final services = ticket['services'] as List;
      final data = ticket['data'] as VisitingDataList;
      final totalAmount = services.fold<double>(0.0, (sum, item) {
        final charge = item['routine_charges'];
        if (charge is int) return sum + charge.toDouble();
        if (charge is double) return sum + charge;
        return sum;
      });

      final userName = ticket['currentUserName'];
      final ticketingPoint = ticket['currentTicketingPoint'];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(Constants.lahoreZoo, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.normal)),
                      pw.SizedBox(height: 5),
                    ],
                  ),
                ),
                pw.Text("Entry Ticket: ${ticket['transection_unique_id']}", style: pw.TextStyle(fontSize: 10)),
                pw.Text("Bill No: ${data.billNo}", style: pw.TextStyle(fontSize: 10)),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text("Services", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  ],
                ),
                ...services.map((typeData) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text(typeData['serviceName'].toString(), style: pw.TextStyle(fontSize: 11)),
                    pw.Text((typeData['routine_charges'] as num).toStringAsFixed(2), style: pw.TextStyle(fontSize: 11)),
                  ],
                )),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Text("Total Paid:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                    pw.Text(totalAmount.toStringAsFixed(2), style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  ],
                ),
                pw.Text(ticketingPoint ?? "", style: pw.TextStyle(fontSize: 11)),
                pw.Text("Date: ${data.date}", style: pw.TextStyle(fontSize: 11)),
                pw.Text(userName ?? "", style: pw.TextStyle(decoration: pw.TextDecoration.underline, fontSize: 11)),
                pw.SizedBox(height: 5),
                pw.Text("Thank you", style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.normal)),
                pw.Text("Valid for Same Day Only", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.normal)),
                pw.Text("Timing 07am to 07pm", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.normal)),
                pw.SizedBox(height: 5),
                pw.Center(
                  child: pw.BarcodeWidget(
                    data: ticket['qr_code_data'],
                    barcode: pw.Barcode.qrCode(),
                    width: 70,
                    height: 70,
                  ),
                ),
              ],
            );
          },
        ),
      );
    }

    print('✅ PDF created with ${ticketList.length} pages, sending to printer...');
    final bytes = await pdf.save();

    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    print('✅ PDF sent to printer successfully');
  }

  static Future<pw.ImageProvider?> _loadImage(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }
}