import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class Template4Pdf {
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
    required String submissionDate
  }) async {
    final pdf = pw.Document();
    const PdfColor primaryBlue = PdfColor.fromInt(0xFFD32F2F);

    final Uint8List imageData = await rootBundle.load('assets/images/cityu_logo.png').then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(imageData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            color: PdfColors.white,
            child: pw.Column(
              children: [
                /// HEADER BANNER
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  color: primaryBlue,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(logoImage, width: 60, height: 60),
                      pw.SizedBox(width: 15),
                      pw.Text(
                        "City University",
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                /// COVER TYPE + COURSE CARD
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(20),
                  margin: const pw.EdgeInsets.all(30),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    border: pw.Border.all(color: primaryBlue, width: 1),
                    borderRadius: pw.BorderRadius.circular(12),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        coverPageType,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text("Course Code: $courseCode"),
                      pw.Text("Course Title: $courseTitle"),
                      if (coverPageType == 'Assignment') ...[
                        pw.SizedBox(height: 10),
                        pw.Text("Assignment Title: $assignmentTitle"),
                      ],
                      if (coverPageType == 'Lab Report') ...[
                        pw.SizedBox(height: 10),
                        pw.Text("Experiment No: $experimentNo"),
                        pw.Text("Experiment Title: $experimentTitle"),
                      ],
                      pw.SizedBox(height: 10),
                      pw.Text("Submission Date: $submissionDate"),
                    ],
                  ),
                ),

                pw.Spacer(),

                /// FOOTER: TWO COLUMN STYLE
                pw.Padding(
                  padding: const pw.EdgeInsets.all(30),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      /// LEFT SIDE: Submitted To
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Submitted To",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(facultyName),
                          if (facultyDesignation != null && facultyDesignation.isNotEmpty)
                            pw.Text(facultyDesignation),
                          pw.Text("Department of $facultyDepartment"),
                          pw.Text("City University"),
                        ],
                      ),

                      /// RIGHT SIDE: Submitted By
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Submitted By",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryBlue,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(studentName),
                          pw.Text("$studentProgram in $studentDepartment"),
                          pw.Text("Batch: $studentBatch"),
                          pw.Text("Student ID: $studentId"),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
