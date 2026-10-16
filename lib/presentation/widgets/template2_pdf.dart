import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class Template2Pdf {
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

    final Uint8List logoData = await rootBundle.load('assets/images/cityu_logo.png').then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(logoData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          String title = '';
          pw.Widget detailsWidget = pw.SizedBox();

          if (coverPageType == 'Assignment') {
            title = "ASSIGNMENT";
            detailsWidget = pw.Text(
              "Assignment: $assignmentTitle",
              style: const pw.TextStyle(fontSize: 14),
            );
          } else if (coverPageType == 'Lab Report') {
            title = "LAB REPORT";
            detailsWidget = pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "Experiment No: $experimentNo",
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Experiment Title: $experimentTitle",
                  style: const pw.TextStyle(fontSize: 14),
                ),
              ],
            );
          }

          return pw.Container(
            color: PdfColors.white,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(30),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  /// Logo
                  pw.Center(child: pw.Image(logoImage, height: 100)),
                  pw.SizedBox(height: 20),

                  pw.Divider(),
                  pw.SizedBox(height: 10),

                  /// University Title
                  pw.Text(
                    "City University",
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.black,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),

                  pw.SizedBox(height: 10),
                  pw.Divider(),
                  pw.SizedBox(height: 35),

                  /// Assignment / Lab Report Title
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.deepPurple,
                    ),
                  ),
                  pw.SizedBox(height: 35),

                  /// Course + Assignment/Lab info in box
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.all(20),
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#f6f3fa'),
                      border: pw.Border.all(
                        color: PdfColor.fromHex('#B39DDB'),
                        width: 2,
                      ),
                      borderRadius: pw.BorderRadius.circular(15),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        detailsWidget,
                        pw.SizedBox(height: 10),
                        pw.Text(
                          "Course Code: $courseCode",
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          "Course Title: $courseTitle",
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(
                          "Submission Date: $submissionDate",
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  /// Submitted To & Submitted By
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: _buildInfoCard(
                          title: "Submitted To",
                          data: [
                            facultyName,
                            "Department of $facultyDepartment",
                            "City University",
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 20),
                      pw.Expanded(
                        child: _buildInfoCard(
                          title: "Submitted By",
                          data: [
                            studentName,
                            "Program: $studentProgram in $studentDepartment",
                            "Batch: $studentBatch",
                            "Student ID: $studentId",
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoCard({
    required String title,
    required List<String> data,
  }) {
    return pw.Container(
      height: 145,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#f6f3fa'),
        border: pw.Border.all(
          color: PdfColor.fromHex('#B39DDB'),
          width: 2,
        ),
        borderRadius: pw.BorderRadius.circular(15),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            for (var item in data)
              pw.Text(
                item,
                style: const pw.TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
