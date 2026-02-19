import 'dart:typed_data';                // Uint8List
import 'dart:ui' as ui;                  // ui.Image, ByteData

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pdf/pdf.dart';           // PdfPageFormat
import 'package:pdf/widgets.dart' as pw; // pw.Document, pw.Image, …

import 'package:printing/printing.dart'; // Printing.layoutPdf

import '../data_models/visiting_data_list/visiting_data_list.dart';
import '../utils/Constants.dart';


class SummaryDialog{

  static final GlobalKey _globalKey = GlobalKey();

  static void showBillDialog(BuildContext context, List<VisitingDataList> billItems) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: 100.w,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(Constants.lahoreZoo, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Bill No.: ${billItems.first.transactionUniqueId}"),
                      //Text("Parking Lot: ${billItems.first.parkingLotId}"),
                      Text("Gate: ${billItems.first.gateName}"),
                      Text("User: ${billItems.first.userName}"),
                      Text("Date: ${billItems.first.date}"),
                      const SizedBox(height: 10),
                      const Divider(),
                      const Text("Bill", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),

                      /// Table Header
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: Colors.black12),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Charges (Rs.)", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          ...billItems.expand((item) {
                            return item.typeWiseData!.map<TableRow>((data) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(data['serviceName'] ?? ''),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${data['count']}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${data['amount']}'),
                                  ),
                                ],
                              );
                            }).toList();
                          }).toList(),
                          TableRow(
                               decoration: const BoxDecoration(color: Color(0xFFEFEFEF)),
                               children: [
                                 const Padding(
                                   padding: EdgeInsets.all(8.0),
                                   child: Text('Totals:', style: TextStyle(fontWeight: FontWeight.bold)),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Text(
                                     '${billItems.first.totalPersons}',
                                     style: const TextStyle(fontWeight: FontWeight.bold),
                                   ),
                                 ),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Text(
                                     '${billItems.first.totalAmount}',
                                     style: const TextStyle(fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Text("Total:"),
                      //     Text("${billItems.first.totalPersons}"),
                      //     Text(
                      //       "Amount: ${billItems.first.totalAmount}/-",
                      //       style: TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final capturedBytes = await _captureWidget(_globalKey);
                          if (capturedBytes != null) {
                            await _createPdfAndPrint(capturedBytes);
                          }
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.print),
                        label: const Text("Print"),
                        style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<Uint8List?> _captureWidget(GlobalKey key) async {
        try {
          RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
          ui.Image image = await boundary.toImage(pixelRatio: 3.0);
          ByteData? byteData = (await image.toByteData(format: ui.ImageByteFormat.png)) as ByteData?;
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

}

