import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PdfViewerScreen extends StatelessWidget {
  final String titre;
  final String? filePath;
  final Uint8List? bytes;

  const PdfViewerScreen({
    super.key, 
    required this.titre, 
    this.filePath, 
    this.bytes
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titre),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
      ),
      body: PdfPreview(
        build: (format) async {
          if (bytes != null) {
            return bytes!;
          } else if (filePath != null) {
            return await File(filePath!).readAsBytes();
          }
          return Uint8List(0);
        },
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        initialPageFormat: PdfPageFormat.a4,
      ),
    );
  }
}
