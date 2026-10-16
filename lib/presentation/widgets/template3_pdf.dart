import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class Template3Pdf {
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

    final Uint8List imageData = await rootBundle.load('assets/images/cityu_logo.png').then((value) => value.buffer.asUint8List());
    final pw.ImageProvider logoImage = pw.MemoryImage(imageData);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Stack(
            children: [
              /// Foreground Layout
              pw.Container(
                color: PdfColors.white,
                padding: const pw.EdgeInsets.all(40),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    /// -------- HEADER --------
                    pw.Center(
                      child: pw.Text(
                        'City University',
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          font: pw.Font.times(),
                          letterSpacing: 1,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Container(height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 25),

                    /// Logo (small, clean)
                    pw.Center(
                      child: pw.Image(logoImage, width: 80, height: 80),
                    ),
                    pw.SizedBox(height: 20),

                    /// -------- COVER PAGE TYPE --------
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      color: PdfColors.black,
                      child: pw.Center(
                        child: pw.Text(
                          coverPageType.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.white,
                          ),
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 30),

                    /// -------- COURSE INFO --------
                    pw.Table(
                      columnWidths: {
                        0: const pw.FlexColumnWidth(2),
                        1: const pw.FlexColumnWidth(4),
                      },
                      border: null,
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text("Course Code:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                            pw.Text(courseCode, style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.SizedBox(height: 8),
                            pw.SizedBox(height: 8),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Text("Course Title:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                            pw.Text(courseTitle, style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                        if (coverPageType == 'Assignment') ...[
                          pw.TableRow(
                            children: [
                              pw.SizedBox(height: 8),
                              pw.SizedBox(height: 8),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Text("Assignment Title:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                              pw.Text(assignmentTitle, style: const pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                        if (coverPageType == 'Lab Report') ...[
                          pw.TableRow(
                            children: [
                              pw.SizedBox(height: 8),
                              pw.SizedBox(height: 8),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Text("Experiment No:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                              pw.Text(experimentNo, style: const pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.SizedBox(height: 8),
                              pw.SizedBox(height: 8),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Text("Experiment Title:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                              pw.Text(experimentTitle, style: const pw.TextStyle(fontSize: 12)),
                            ],
                          ),
                        ],
                        pw.TableRow(
                          children: [
                            pw.SizedBox(height: 8),
                            pw.SizedBox(height: 8),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Text("Submission Date:", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                            pw.Text(submissionDate, style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),

                    pw.Spacer(),
                    /// -------- SUBMISSION DETAILS --------
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        /// Submitted To (left accent line)
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Submitted To", style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 5),
                                pw.Text(facultyName, style: const pw.TextStyle(fontSize: 12)),
                                if (facultyDesignation != null && facultyDesignation.isNotEmpty)
                                  pw.Text(facultyDesignation, style: const pw.TextStyle(fontSize: 12)),
                                pw.Text("Department of $facultyDepartment", style: const pw.TextStyle(fontSize: 12)),
                                pw.Text("City University", style: const pw.TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        pw.SizedBox(width: 20),

                        /// Submitted By (right accent line)
                        pw.Expanded(
                          child: pw.Container(
                            padding: const pw.EdgeInsets.all(10),
                            decoration: const pw.BoxDecoration(
                              border: pw.Border(
                                left: pw.BorderSide(color: PdfColors.black, width: 1),
                              ),
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("Submitted By", style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 5),
                                pw.Text(studentName, style: const pw.TextStyle(fontSize: 12)),
                                pw.Text('$studentProgram in $studentDepartment', style: const pw.TextStyle(fontSize: 12)),
                                pw.Text('Batch: $studentBatch', style: const pw.TextStyle(fontSize: 12)),
                                pw.Text('Student ID: $studentId', style: const pw.TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 30),
                    pw.Container(height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 5),
                    pw.Center(
                      child: pw.Text(
                        "Powered by CityU Cover Page | Simplifying Your Academic Cover Pages",
                        style: pw.TextStyle(
                          fontSize: 8,
                          letterSpacing: 1,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Background Watermark
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Opacity(
                    opacity: 0.10,
                    child: pw.Image(logoImage, width: 230, height: 230),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
