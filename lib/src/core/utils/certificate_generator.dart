import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class CertificateGenerator {
  static final CertificateGenerator _instance =
      CertificateGenerator._internal();
  factory CertificateGenerator() => _instance;
  CertificateGenerator._internal() {
    // Initialize fonts ONCE when singleton is created
    _initializeFonts();
  }

  // Use regular variables, not `late`
  pw.Font? _fontRegular;
  pw.Font? _fontBold;

  // Track if fonts are loaded
  bool _fontsLoaded = false;

  Future<void> _initializeFonts() async {
    if (_fontsLoaded) return; // Prevent double init

    try {
      final regularData = await rootBundle.load('assets/fonts/NRT-Reg.ttf');
      final boldData = await rootBundle.load('assets/fonts/NRT-Bd.ttf');

      _fontRegular = pw.Font.ttf(regularData);
      _fontBold = pw.Font.ttf(boldData);
      _fontsLoaded = true;
    } catch (e) {
      debugPrint('Font loading failed: $e');
      rethrow;
    }
  }

  Future<String?> generateAndSaveCertificate({
    required String userName,
    required String courseName,
    required String instructorId,
    required Future<String> Function(String) getInstructorName,
    String? completionDate,
  }) async {
    try {
      final instructorName = await getInstructorName(instructorId);
      final filePath = await generateCertificate(
        userName: userName,
        courseName: courseName,
        instructorName: instructorName,
        completionDate: completionDate,
      );
      return filePath;
    } catch (e) {
      debugPrint('Certificate generation error: $e');
      return null;
    }
  }

  Future<String> generateCertificate({
    required String userName,
    required String courseName,
    required String instructorName,
    String? completionDate,
  }) async {
    await _initializeFonts();

    final date = completionDate ?? _formatDate(DateTime.now());
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(40),
        build: (_) => _buildCertificateContent(
          userName: userName,
          courseName: courseName,
          instructorName: instructorName,
          completionDate: date,
        ),
      ),
    );

    return await _savePdfToFile(pdf, userName, courseName);
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (_) {
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  // Helper method to detect if text contains Kurdish/Arabic characters
  bool _containsKurdishText(String text) {
    // Check for Arabic/Kurdish Unicode range
    return text.runes.any((rune) => rune >= 0x0600 && rune <= 0x06FF);
  }

  // Helper method to create text with automatic RTL detection for course names
  pw.Widget _buildText(
    String text, {
    double fontSize = 16,
    bool isBold = false,
    pw.TextAlign textAlign = pw.TextAlign.center,
  }) {
    // If text contains Kurdish characters, use RTL direction
    if (_containsKurdishText(text)) {
      return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            font: isBold ? _fontBold : _fontRegular,
            fontSize: fontSize,
          ),
          textAlign: textAlign,
        ),
      );
    }

    // Otherwise use LTR (standard English)
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: isBold ? _fontBold : _fontRegular,
        fontSize: fontSize,
      ),
      textAlign: textAlign,
    );
  }

  pw.Widget _buildCertificateContent({
    required String userName,
    required String courseName,
    required String instructorName,
    required String completionDate,
  }) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue900, width: 8),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),
      ),
      child: pw.Container(
        padding: const pw.EdgeInsets.all(20),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.blue700, width: 2),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(15)),
        ),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            // Certificate Title - English Only
            pw.Text(
              'CERTIFICATE OF COMPLETION',
              style: pw.TextStyle(
                font: _fontBold,
                fontSize: 32,
                letterSpacing: 2,
                color: PdfColors.blue900,
              ),
            ),

            pw.SizedBox(height: 10),
            pw.Container(
              width: 300,
              height: 3,
              decoration: pw.BoxDecoration(
                gradient: const pw.LinearGradient(
                  colors: [
                    PdfColors.blue200,
                    PdfColors.blue900,
                    PdfColors.blue200,
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 30),

            // "This certifies that" text
            pw.Text(
              'This certifies that',
              style: pw.TextStyle(
                font: _fontRegular,
                fontSize: 16,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey700,
              ),
            ),

            pw.SizedBox(height: 15),

            // User Name - Supports both English and Kurdish
            _buildText(userName, fontSize: 36, isBold: true),

            pw.SizedBox(height: 15),
            pw.Container(width: 400, height: 2, color: PdfColors.blue700),
            pw.SizedBox(height: 25),

            // "has successfully completed the course"
            pw.Text(
              'has successfully completed the course',
              style: pw.TextStyle(
                font: _fontRegular,
                fontSize: 16,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey700,
              ),
            ),

            pw.SizedBox(height: 15),

            // Course Name - Supports both English and Kurdish
            pw.Container(
              width: 500,
              child: _buildText(courseName, fontSize: 24, isBold: true),
            ),

            pw.SizedBox(height: 30),

            // Signature sections
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                _buildSignatureSection('Date', completionDate),
                pw.SizedBox(width: 50),
                _buildSignatureSection('Instructor', instructorName),
              ],
            ),

            pw.SizedBox(height: 20),
            _buildDecorativeSeal(),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildSignatureSection(String title, String value) {
    return pw.Column(
      children: [
        pw.Container(
          width: 200,
          padding: const pw.EdgeInsets.only(bottom: 5),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey700, width: 1.5),
            ),
          ),
          child: _buildText(value, fontSize: 14, isBold: true),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          title,
          style: pw.TextStyle(
            font: _fontRegular,
            fontSize: 12,
            color: PdfColors.grey600,
            fontStyle: pw.FontStyle.italic,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDecorativeSeal() {
    return pw.Container(
      width: 80,
      height: 80,
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: PdfColors.blue100,
        border: pw.Border.all(color: PdfColors.blue900, width: 3),
      ),
      child: pw.Center(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text(
              '★',
              style: pw.TextStyle(
                font: _fontBold,
                fontSize: 24,
                color: PdfColors.blue900,
              ),
            ),
            pw.Text(
              'CERTIFIED',
              style: pw.TextStyle(
                font: _fontBold,
                fontSize: 8,
                color: PdfColors.blue900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _savePdfToFile(
    pw.Document pdf,
    String userName,
    String courseName,
  ) async {
    final dir = await getApplicationDocumentsDirectory();
    final certDir = Directory('${dir.path}/certificates');
    if (!await certDir.exists()) await certDir.create(recursive: true);

    final safeUser = _safeFileName(userName);
    final safeCourse = _safeFileName(courseName);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final filePath =
        '${certDir.path}/certificate_${safeUser}_${safeCourse}_$timestamp.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());
    return filePath;
  }

  String _safeFileName(String name) => name
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '_')
      .toLowerCase();
}
