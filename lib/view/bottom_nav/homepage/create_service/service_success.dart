import 'package:champion_car_wash_app/view/bottom_nav/bottom_nav.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ServiceSuccessScreen extends StatefulWidget {
  final String customerName;
  final String make;
  final String model;
  final String purchaseDate; // ISO string e.g., 2025-06-10
  final String engineNumber;
  final String serviceType; // e.g., Car Wash
  final String washType; // e.g., Super wash
  final double price;
  final String locationName;

  const ServiceSuccessScreen({
    super.key,
    required this.customerName,
    required this.make,
    required this.model,
    required this.purchaseDate,
    required this.engineNumber,
    required this.serviceType,
    required this.washType,
    required this.price,
    required this.locationName,
  });

  @override
  State<ServiceSuccessScreen> createState() => _ServiceSuccessScreenState();
}

class _ServiceSuccessScreenState extends State<ServiceSuccessScreen> {
  pw.TableRow _row(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 12)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
  Future<void> _printReceipt() async {
    final doc = pw.Document();

    final serviceName = widget.locationName;
    final serviceType = widget.serviceType;
    final qrPayload = {
      'customer_name': widget.customerName,
      'make': widget.make,
      'model': widget.model,
      'purchase_date': widget.purchaseDate,
      'engine_number': widget.engineNumber,
      'service_type': widget.serviceType,
      'wash_type': widget.washType,
      'price': widget.price,
      'location_name': widget.locationName,
      'created_at': DateTime.now().toIso8601String(),
    };
    final qrData = jsonEncode(qrPayload);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Service Receipt',
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(),
                pw.SizedBox(height: 12),
                pw.Text('Location: $serviceName', style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Service: $serviceType', style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Date: ${DateTime.now().toLocal()}', style: const pw.TextStyle(fontSize: 12)),
                pw.SizedBox(height: 16),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(2),
                    1: const pw.FlexColumnWidth(3),
                  },
                  children: [
                    _row('Customer', widget.customerName),
                    _row('Make', widget.make),
                    _row('Model', widget.model),
                    _row('Purchase Date', widget.purchaseDate),
                    _row('Engine #', widget.engineNumber),
                    _row('Service Type', widget.serviceType),
                    _row('Wash Type', widget.washType),
                    _row('Price', widget.price.toStringAsFixed(2)),
                  ],
                ),
                pw.SizedBox(height: 24),
                pw.Center(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(8),
                    ),
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.Text('Scan to verify', style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 8),
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: qrData,
                          width: 180,
                          height: 180,
                        ),
                      ],
                    ),
                  ),
                ),
                pw.Spacer(),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Thank you for choosing $serviceName',
                    style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F4EA),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: Colors.green,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Service Created Successfully',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  QrImageView(
                    data: jsonEncode({
                      'customer_name': widget.customerName,
                      'make': widget.make,
                      'model': widget.model,
                      'purchase_date': widget.purchaseDate,
                      'engine_number': widget.engineNumber,
                      'service_type': widget.serviceType,
                      'wash_type': widget.washType,
                      'price': widget.price,
                    }),
                    size: 180.0,
                  ),
                  const SizedBox(height: 16),
                  Text(widget.customerName, style: const TextStyle(fontSize: 16)),
                  Text(
                    '${widget.serviceType} • ${widget.washType}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _printReceipt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Print',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Navigate back to HomePageContent and clear the navigation stack
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const BottomNavigation(),
                          ),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
