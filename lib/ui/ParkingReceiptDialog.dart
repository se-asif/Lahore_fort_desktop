

import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';


import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../data_models/visiting_data_list/visiting_data_list.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utils/Constants.dart';



class ParkingReceiptDialog {
  static final GlobalKey _globalKey = GlobalKey();

  static void show(BuildContext context, List<VisitingDataList>? visitorDataList) {
    if (visitorDataList == null || visitorDataList.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final List<Map<String, dynamic>> ticketList = [];

        print("list in dilog ${visitorDataList.toString()}");
        for (final data in visitorDataList) {
          // Group typeWiseData by visitorTypeId
          final Map<int, List<Map<String, dynamic>>> groupedByVisitorType = {};

          for (final typeData in data.typeWiseData ?? []) {
            final rawVisitorTypeId = typeData['visitorTypeId'];
            final visitorTypeId = rawVisitorTypeId is int
                ? rawVisitorTypeId
                : int.tryParse(rawVisitorTypeId.toString()) ?? -1;

            groupedByVisitorType.putIfAbsent(visitorTypeId, () => []).add(typeData);
          }


          for (final entry in groupedByVisitorType.entries) {
            final visitorTypeId = entry.key;
            final services = entry.value;

            // Find max count in this group
            final maxCount = services
                .map((e) => e['count'] as int? ?? 0)
                .reduce((a, b) => a > b ? a : b);

            for (int i = 0; i < maxCount; i++) {
              final List<Map<String, dynamic>> servicesForThisTicket = [];

              for (final service in services) {
                final count = service['count'] as int? ?? 0;
                if (i < count) {
                  servicesForThisTicket.add({
                    'serviceName': service['serviceName'],
                    'routine_charges':
                        double.tryParse(service['routine_charges'].toString()) ?? 0.0,
                  });
                }
              }

              if (servicesForThisTicket.isNotEmpty) {
                // Try to find transaction_unique_id for this ticket index
                String? transactionId;

                for (final service in services) {
                  final tranIds = service['transection_unique_ids'];
                  if (tranIds is List && i < tranIds.length) {
                    transactionId = tranIds[i].toString();
                    break; // Use the first matching one
                  }
                }

                ticketList.add({
                  'transection_unique_id': transactionId ?? '${DateTime.now().millisecondsSinceEpoch}-$i',
                  'services': servicesForThisTicket,
                  'visitorTypeId': visitorTypeId,
                  'data': data,
                });
              }

            }
          }
        }




        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 0.8.sh), // Limit dialog height to 80% of screen
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Scrollable ticket list inside RepaintBoundary
                  Expanded(
                    child: SingleChildScrollView(
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          constraints: BoxConstraints(maxWidth: 100.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              // Build all tickets
                              ...ticketList.map((ticket) {
                                final services = ticket['services'] as List;
                                final data = ticket['data'] as VisitingDataList;
                                final totalAmount = services.fold<double>(0.0, (sum, item) {
                                  final charge = item['routine_charges'];
                                  if (charge is int) return sum + charge.toDouble();
                                  if (charge is double) return sum + charge;
                                  return sum;
                                });

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
                                    Text("Entry Ticket: ${ticket['transection_unique_id']}",
                                        style: TextStyle(fontSize: 18)),
                                    const SizedBox(height: 3),
                                    Text("Bill No: ${data.billNo}",
                                                                            style: TextStyle(fontSize: 18)),
                                                                        const SizedBox(height: 10),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Services",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        Text("Amount",
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    ...services.map((typeData) => Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(typeData['serviceName'].toString(),
                                              style: TextStyle(fontSize: 18)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            (typeData['routine_charges'] is num
                                                ? (typeData['routine_charges'] as num).toDouble()
                                                : 0.0).toStringAsFixed(2),
                                            style: TextStyle(fontSize: 18)
                                          ),
                                        ),
                                      ],
                                    )),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text("Total Paid:",
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Text(
                                            totalAmount.toStringAsFixed(2),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(data.ticketingPoint ?? "",
                                        style: const TextStyle(fontSize: 16)),
                                    Text("Date: ${data.date}",
                                        style: const TextStyle(fontSize: 18)),
                                    Text(
                                      data.userName ?? "",
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue, fontSize: 18
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text("Thank you",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const Text("Valid for Same Day Only",
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 3),
                                    const Text("Timing 07am to 07pm",
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: QrImageView(
                                        data: ticket['transection_unique_id'],
                                        version: QrVersions.auto,
                                        size: 110.0,
                                      ),
                                    ),
                                    const Divider(thickness: 2),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Print button OUTSIDE the RepaintBoundary
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // final capturedBytes = await _captureWidget(_globalKey);
                        // if (capturedBytes != null) {
                        //   await _createPdfAndPrint(capturedBytes);
                        //
                        // }
                        _createPdfFromData(ticketList);
                        Navigator.pop(context);
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
    final pdf = pw.Document();

    // Load the logo image
    final logoImage = await _loadImage('assets/images/lahore_fort_logo.png');

    for (final ticket in ticketList) {
      final services = ticket['services'] as List;
      final data = ticket['data'] as VisitingDataList;
      final totalAmount = services.fold<double>(0.0, (sum, item) {
        final charge = item['routine_charges'];
        if (charge is int) return sum + charge.toDouble();
        if (charge is double) return sum + charge;
        return sum;
      });

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Column(
                    children: [
                      logoImage != null
                          ? pw.Image(logoImage, height: 100, width: 100)
                          : pw.Container(),
                      pw.Text(
                        Constants.lahoreZoo,
                        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.normal),
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                ),
                pw.Text("Entry Ticket: ${ticket['transection_unique_id']}",
                    style: pw.TextStyle(fontSize: 11)),
                pw.SizedBox(height: 3),
                pw.Text("Bill No: ${data.billNo}",
                                    style: pw.TextStyle(fontSize: 11)),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(width: 1.sp),
                    pw.Text("Services",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 12)),
                    pw.Text("Amount",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 12)),
                    pw.SizedBox(width: 1.sp),
                  ],
                ),
                pw.SizedBox(height: 5),
                ...services.map((typeData) => pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(width: 1.sp),
                    pw.Text(typeData['serviceName'].toString(),
                          style: pw.TextStyle(fontSize: 12)),

                    // pw.Padding(
                    //   padding:
                    pw.SizedBox(width: 5),
                    pw.Text(
                        (typeData['routine_charges'] is num
                            ? (typeData['routine_charges'] as num).toDouble()
                            : 0.0).toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 12)
                      ),
                    pw.SizedBox(width: 1.sp),
                    //),
                  ],
                )),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.SizedBox(width: 1.w),
                    pw.Text("Total Paid:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),

                    pw.Text(
                        totalAmount.toStringAsFixed(2),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 12),
                      ),
                    pw.SizedBox(width: 1.w),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Text(data.ticketingPoint ?? "",
                    style: pw.TextStyle(fontSize: 13)),
                pw.Text("Date: ${data.date}",
                    style: pw.TextStyle(fontSize: 13)),
                pw.Text(
                  data.userName ?? "",
                  style: pw.TextStyle(
                    decoration: pw.TextDecoration.underline,
                    color: PdfColors.blue, fontSize: 13
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text("Thank you",
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.normal)),
                pw.Text("Valid for Same Day Only", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)),
                pw.SizedBox(height: 3),
                pw.Text("Timing 07am to 07pm", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal)),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.BarcodeWidget(
                    data: ticket['transection_unique_id'],
                    barcode: pw.Barcode.qrCode(),
                    width: 110,
                    height: 110,
                  ),
                ),
               // pw.Divider(thickness: 2),
              ],
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Helper function to load images
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

  static Future<Uint8List?> _captureWidget(GlobalKey key) async {
      try {
        RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      } catch (e) {
        print('Error capturing widget: $e');
        return null;
      }
    }

    static Future<void> _createPdfAndPrint(Uint8List imageBytes) async {
      final pdf = pw.Document();

      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80, // For 80mm POS printers
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );

      // Print or share the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }

  static Future<void> _generatePDF(List<VisitingDataList>? visitorDataList) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll80, // 80mm roll paper format
          build: (pw.Context context) {
            return pw.Column(

              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: visitorDataList!.expand((data) {
                return data.typeWiseData!.expand((typeData) {
                  return List.generate(typeData['count'], (index) {
                    return pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        // **Logo**
                        pw.Image(
                          pw.MemoryImage(
                            File('assets/images/safari_logo.png').readAsBytesSync(),
                          ),
                          height: 50,
                          width: 50,
                        ),
                        pw.SizedBox(height: 5),

                        // **Title**
                        pw.Text("Safari Zoo Parking",
                            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.Text("Parking Receipt",
                            style: pw.TextStyle(fontSize: 13, color: PdfColors.grey)),
                        pw.SizedBox(height: 10),

                        // **Entry Ticket**
                        pw.Text("Entry Ticket: ${typeData['transection_unique_ids']}"),
                        pw.SizedBox(height: 10),

                        // **Category & Amount**
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            pw.Text("Category", style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                            pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
                          ],
                        ),
                        pw.SizedBox(height: 5),

                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                          children: [
                            pw.Text("${typeData['serviceName']}"),
                            pw.Text("${typeData['routine_charges']}"),
                          ],
                        ),
                        pw.SizedBox(height: 10),

                        // **Paid Amount**
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Paid:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            pw.Text("${typeData['routine_charges']}",
                                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 10),

                        // **Footer Information**
                        pw.Text("Ticketing Point: ${data.ticketingPoint}", style: pw.TextStyle(fontSize: 14)),
                        pw.Text("Date: ${data.date}"),
                        pw.Text(data.userName.toString(),
                            style: pw.TextStyle(
                                decoration: pw.TextDecoration.underline, color: PdfColors.blue)),
                        pw.SizedBox(height: 10),

                        // **Thank You Message**
                        pw.Text("Thank you",
                            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 10),

                        pw.Divider(thickness: 2), // Separate each receipt
                        pw.SizedBox(height: 10),
                      ],
                    );
                  });
                }).toList();
              }).toList(),
            );
          },
        ),
      );

      // Save the PDF
      final directory = await getApplicationDocumentsDirectory();
      final pdfPath = '${directory.path}/receipt.pdf';
      final pdfFile = File(pdfPath);
      await pdfFile.writeAsBytes(await pdf.save());

      print("PDF saved at: $pdfPath");

      // Open the PDF
      //OpenFile.open(pdfPath);

      // Print the PDF
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

    } catch (e) {
      print("Error generating PDF: $e");
    }
  }


}
