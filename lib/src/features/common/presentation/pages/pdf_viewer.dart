import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfPreviewPage extends StatelessWidget {
  final String filePath;

  const PdfPreviewPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final file = File(filePath);

    return Scaffold(
      appBar: AppBar(title: const Text('Certificate Preview')),
      body: file.existsSync()
          ? SfPdfViewer.file(file)
          : const Center(child: Text('File not found')),
    );
  }
}
