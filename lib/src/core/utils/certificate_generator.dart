import 'dart:io';
import 'dart:typed_data';
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
    bool isKurdish = true, // Add this parameter for language selection
  }) async {
    try {
      final instructorName = await getInstructorName(instructorId);
      final filePath = await generateCertificate(
        userName: userName,
        courseName: courseName,
        instructorName: instructorName,
        completionDate: completionDate,
        isKurdish: isKurdish,
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
    bool isKurdish = true,
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
          isKurdish: isKurdish,
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

  // Helper method to create RTL text with proper Kurdish support
  pw.Widget _buildKurdishText(
    String text, {
    double fontSize = 16,
    bool isBold = false,
  }) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: isBold ? _fontBold : _fontRegular,
          fontSize: fontSize,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  // Helper method to create English text
  pw.Widget _buildEnglishText(
    String text, {
    double fontSize = 16,
    bool isBold = false,
  }) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: isBold ? _fontBold : _fontRegular,
        fontSize: fontSize,
      ),
      textAlign: pw.TextAlign.center,
    );
  }

  pw.Widget _buildCertificateContent({
    required String userName,
    required String courseName,
    required String instructorName,
    required String completionDate,
    required bool isKurdish,
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
            // Certificate Title - Bilingual
            isKurdish
                ? _buildKurdishText(
                    'بڕوانامەی تەواوکردن',
                    fontSize: 32,
                    isBold: true,
                  )
                : pw.Text(
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
            isKurdish
                ? _buildKurdishText('ئەم بڕوانامەیە پێشکەشە بە')
                : pw.Text(
                    'This certifies that',
                    style: pw.TextStyle(
                      font: _fontRegular,
                      fontSize: 16,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey700,
                    ),
                  ),

            pw.SizedBox(height: 15),

            // User Name - Always RTL for Kurdish names
            _buildKurdishText(userName, fontSize: 36, isBold: true),

            pw.SizedBox(height: 15),
            pw.Container(width: 400, height: 2, color: PdfColors.blue700),
            pw.SizedBox(height: 25),

            // "has successfully completed the course"
            isKurdish
                ? _buildKurdishText('بە سەرکەوتوویی ئەم کۆرسەی تەواو کردووە')
                : pw.Text(
                    'has successfully completed the course',
                    style: pw.TextStyle(
                      font: _fontRegular,
                      fontSize: 16,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey700,
                    ),
                  ),

            pw.SizedBox(height: 15),

            // Course Name - Always RTL for Kurdish course names
            pw.Container(
              width: 500,
              child: _buildKurdishText(courseName, fontSize: 24, isBold: true),
            ),

            pw.SizedBox(height: 30),

            // Signature sections
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                _buildSignatureSection(
                  isKurdish ? 'بەروار' : 'Date',
                  completionDate,
                  isKurdish: isKurdish,
                ),
                pw.SizedBox(width: 50),
                _buildSignatureSection(
                  isKurdish ? 'مامۆستا' : 'Instructor',
                  instructorName,
                  isKurdish: isKurdish,
                ),
              ],
            ),

            pw.SizedBox(height: 20),
            _buildDecorativeSeal(isKurdish: isKurdish),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildSignatureSection(
    String title,
    String value, {
    bool isKurdish = true,
  }) {
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
          child: isKurdish
              ? _buildKurdishText(value, fontSize: 14, isBold: true)
              : pw.Text(
                  value,
                  style: pw.TextStyle(
                    font: _fontBold,
                    fontSize: 14,
                    color: PdfColors.grey800,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
        ),
        pw.SizedBox(height: 5),
        isKurdish
            ? _buildKurdishText(title, fontSize: 12)
            : pw.Text(
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

  pw.Widget _buildDecorativeSeal({bool isKurdish = true}) {
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
            isKurdish
                ? _buildKurdishText('*', fontSize: 20, isBold: true)
                : pw.Text(
                    'Star',
                    style: pw.TextStyle(
                      font: _fontBold,
                      fontSize: 20,
                      color: PdfColors.blue900,
                    ),
                  ),
            isKurdish
                ? _buildKurdishText('بڕوانامە', fontSize: 8, isBold: true)
                : pw.Text(
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

  // Alternative method using TextPainter for complex text layout (if needed)
  Future<pw.MemoryImage> _createTextImage(
    String text, {
    double fontSize = 16,
    bool isBold = false,
  }) async {
    final paragraph = pw.Paragraph(
      text: text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        font: isBold ? _fontBold : _fontRegular,
        fontSize: fontSize,
      ),
    );

    // This is a simplified approach - for more complex text rendering,
    // you might need to use Flutter's TextPainter and convert to image
    return _textToImage(text, fontSize: fontSize, isBold: isBold);
  }

  // Method to convert text to image using Flutter's TextPainter
  Future<pw.MemoryImage> _textToImage(
    String text, {
    double fontSize = 16,
    bool isBold = false,
  }) async {
    // This would require rendering the text as an image in Flutter
    // and then converting to PDF image. This is more complex but
    // provides better control over text rendering.

    // For now, we'll use the direct text approach which works well
    // with proper RTL support in the pdf package
    throw UnimplementedError('Text to image conversion not implemented');
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
