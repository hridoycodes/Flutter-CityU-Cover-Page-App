import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class Template1Pdf {
  static Future<Uint8List> generate({
    required String coverPageType,
    required String courseCode,
    required String courseTitle,
    String assignmentTitle = '',
    String experimentNo = '',
    String experimentTitle = '',
    required String facultyName,
    String? facultyDesignation,
    required String facultyDepartment,
    required String studentName,
    required String studentDepartment,
    required String studentProgram,
    required String studentBatch,
    required String studentId,
    required String submissionDate,
  }) async {
    final pdf = pw.Document();

    // Load university logo
    final Uint8List imageData = await rootBundle.load('assets/images/cityu_logo.png').then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(imageData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        // margin: const pw.EdgeInsets.all(30),
        theme: pw.ThemeData.withFont(
          base: pw.Font.helvetica(),
        ),
        build: (context) {
          return pw.Container(
            width: double.infinity,
            height: double.infinity,
            color: PdfColors.white,
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                /// University Title
                pw.Text(
                  'City University',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.purple900,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 20),

                /// Logo
                pw.Center(child: pw.Image(logoImage, width: 100, height: 100)),
                pw.SizedBox(height: 20),

                /// Cover Page Type (Assignment / Lab Report)
                pw.Text(coverPageType, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black,),),
                pw.SizedBox(height: 20),

                /// Course Info
                pw.Text(courseCode, style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey800)),
                pw.SizedBox(height: 4),
                pw.Text(courseTitle, style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.black)),

                pw.SizedBox(height: 20),

                /// Assignment / Lab Report Details
                if (coverPageType == 'Assignment')
                  pw.Text('Assignment: $assignmentTitle', style: const pw.TextStyle(fontSize: 14)),
                if (coverPageType == 'Lab Report') ...[
                  pw.Text('Experiment No: $experimentNo', style: const pw.TextStyle(fontSize: 14)),
                  pw.SizedBox(height: 4),
                  pw.Text('Experiment Title: $experimentTitle', style: const pw.TextStyle(fontSize: 14)),
                ],

                pw.SizedBox(height: 20),
                pw.Text('Submission Date: $submissionDate', style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),

                pw.SizedBox(height: 20),
                /// Divider
                pw.Divider(thickness: 1, color: PdfColors.grey500),
                pw.SizedBox(height: 20),

                /// Submitted To
                pw.Text('Submitted To', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.purple900)),
                pw.SizedBox(height: 10),
                pw.Text(facultyName, style: const pw.TextStyle(fontSize: 12)),
                if (facultyDesignation != null && facultyDesignation.isNotEmpty)
                  pw.Text(facultyDesignation, style: const pw.TextStyle(fontSize: 12)),
                pw.Text('Department of $facultyDepartment', style: const pw.TextStyle(fontSize: 12)),
                pw.Text('City University', style: const pw.TextStyle(fontSize: 12)),

                pw.SizedBox(height: 30),

                /// Submitted By
                pw.Text('Submitted By', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.purple900)),
                pw.SizedBox(height: 10),
                pw.Text(studentName, style: const pw.TextStyle(fontSize: 12)),
                pw.Text('Program: $studentProgram in $studentDepartment', style: const pw.TextStyle(fontSize: 12)),
                pw.Text('Batch: $studentBatch', style: const pw.TextStyle(fontSize: 12)),
                pw.Text('Student ID: $studentId', style: const pw.TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
