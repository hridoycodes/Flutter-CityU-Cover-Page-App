import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cityu_cover_page/core/utils/message_utils.dart';
import 'package:cityu_cover_page/data/local/local_storage_service.dart';
import 'package:cityu_cover_page/data/services/pdf_to_image_service.dart';
import 'package:cityu_cover_page/presentation/cubit/save_as_image_selection_cubit.dart';
import 'package:cityu_cover_page/presentation/cubit/template_selection_cubit.dart';
import 'package:cityu_cover_page/presentation/widgets/bottom_sheet_widget.dart';
import 'package:cityu_cover_page/presentation/widgets/custom_text_field.dart';
import 'package:cityu_cover_page/presentation/widgets/selectable_tile.dart';
import 'package:cityu_cover_page/presentation/widgets/template1_pdf.dart';
import 'package:cityu_cover_page/presentation/widgets/template2_pdf.dart';
import 'package:cityu_cover_page/presentation/widgets/template3_pdf.dart';
import 'package:cityu_cover_page/presentation/widgets/template4_pdf.dart';
import 'package:printing/printing.dart';

class CityUColors {
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color brightRed = Color(0xFFD32F2F);
  static const Color lightRed = Color(0xFFFFEBEE);
  static const Color cardBorder = Color(0xFFE0E0E0);
}

class FieldsScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const FieldsScreen());

  const FieldsScreen({super.key});

  @override
  State<FieldsScreen> createState() => _FieldsScreenState();
}

class _FieldsScreenState extends State<FieldsScreen> {
  final TextEditingController _coverPageType = TextEditingController();
  final TextEditingController _courseCode = TextEditingController();
  final TextEditingController _courseName = TextEditingController();
  final TextEditingController _assignmentName = TextEditingController();
  final TextEditingController _experimentNo = TextEditingController();
  final TextEditingController _experimentName = TextEditingController();
  final TextEditingController _facultyName = TextEditingController();
  final TextEditingController _facultyDesignation = TextEditingController();
  final TextEditingController _facultyDepartment = TextEditingController();
  final TextEditingController _studentName = TextEditingController();
  final TextEditingController _studentDepartment = TextEditingController();
  final TextEditingController _studentProgram = TextEditingController();
  final TextEditingController _studentBatchName = TextEditingController();
  final TextEditingController _studentId = TextEditingController();
  final TextEditingController _submissionDate = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> facultyDepartments = ['CSE', 'EEE', 'ENG', 'BBA', 'CE', 'LLB', 'BSTE', 'TE', 'GED'];
  final List<String> studentDepartments = ['CSE', 'EEE', 'ENG', 'BBA', 'CE', 'LLB', 'BSTE', 'TE', 'GED'];
  final List<String> programs = ['B.Sc', 'M.Sc', 'B.A', 'M.A', 'LLM'];
  final List<String> coverPageTypes = ['Assignment', 'Lab Report'];

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  _fetchStudentData() async {
    try {
      LocalStorageService localStorageService = LocalStorageService();
      _studentName.text = (await localStorageService.getStudentName()) ?? '';
      _studentDepartment.text = (await localStorageService.getStudentDepartment()) ?? '';
      _studentProgram.text = (await localStorageService.getStudentProgram()) ?? '';
      _studentBatchName.text = (await localStorageService.getStudentBatch()) ?? '';
      _studentId.text = (await localStorageService.getStudentId()) ?? '';
    } catch (e) {
      debugPrint("Error fetching local data: $e");
    }
  }

  _saveStudentData() async {
    try {
      LocalStorageService localStorageService = LocalStorageService();
      await localStorageService.saveStudentName(_studentName.text);
      await localStorageService.saveStudentDepartment(_studentDepartment.text);
      await localStorageService.saveStudentProgram(_studentProgram.text);
      await localStorageService.saveStudentBatch(_studentBatchName.text);
      await localStorageService.saveStudentId(_studentId.text);
    } catch (e) {
      debugPrint("Error saving local data: $e");
    }
  }

  void _showBottomSheet({
    required String title,
    required List<String> items,
    required TextEditingController controller,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return BottomSheetWidget(
          label: title,
          itemName: controller.text,
          items: items,
          onSelectItem: (String item) {
            setState(() {
              controller.text = item;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Cover Page Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        backgroundColor: CityUColors.primaryRed,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(
                  title: "Course & Task Information",
                  icon: Icons.book_rounded,
                  children: [
                    CustomTextField(
                      controller: _coverPageType,
                      label: 'Cover Page Type *',
                      hintText: 'Select the type of cover page',
                      isRequired: true,
                      readOnly: true,
                      onTap: () => _showBottomSheet(
                        title: 'Select Cover Page Type',
                        items: coverPageTypes,
                        controller: _coverPageType,
                      ),
                      validationLabel: 'Cover page type',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _courseCode,
                      label: 'Course Code *',
                      hintText: 'Enter your course code',
                      isRequired: true,
                      validationLabel: 'Course code',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _courseName,
                      label: 'Course Title *',
                      hintText: 'Enter the full course name',
                      isRequired: true,
                      validationLabel: 'Course title',
                    ),
                    if (_coverPageType.text == 'Assignment') ...[
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _assignmentName,
                        label: 'Assignment Title *',
                        hintText: 'Enter assignment title',
                        isRequired: true,
                        validationLabel: 'Assignment title',
                      ),
                    ],
                    if (_coverPageType.text == 'Lab Report') ...[
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _experimentNo,
                        label: 'Experiment Number *',
                        hintText: 'Enter experiment number',
                        isRequired: true,
                        keyboardType: TextInputType.number,
                        validationLabel: 'Experiment number',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _experimentName,
                        label: 'Experiment Title *',
                        hintText: 'Enter experiment title',
                        isRequired: true,
                        validationLabel: 'Experiment title',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: "Faculty Details",
                  icon: Icons.person_outline_rounded,
                  children: [
                    CustomTextField(
                      controller: _facultyName,
                      label: 'Faculty Name *',
                      hintText: 'Enter faculty name',
                      isRequired: true,
                      validationLabel: 'Faculty name',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _facultyDesignation,
                      label: 'Designation',
                      hintText: 'Enter faculty designation',
                      validationLabel: 'Faculty designation',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _facultyDepartment,
                      label: 'Department *',
                      hintText: 'Select faculty department',
                      readOnly: true,
                      isRequired: true,
                      onTap: () => _showBottomSheet(
                        title: 'Choose Department',
                        items: facultyDepartments,
                        controller: _facultyDepartment,
                      ),
                      validationLabel: 'Faculty department',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: "Student Details",
                  icon: Icons.badge_outlined,
                  children: [
                    CustomTextField(
                      controller: _studentName,
                      label: 'Student Name *',
                      hintText: 'Enter your full name',
                      isRequired: true,
                      validationLabel: 'Student name',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _studentDepartment,
                      label: 'Department *',
                      hintText: 'Select your department',
                      readOnly: true,
                      isRequired: true,
                      onTap: () => _showBottomSheet(
                        title: 'Select Department',
                        items: studentDepartments,
                        controller: _studentDepartment,
                      ),
                      validationLabel: 'Department',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _studentProgram,
                      label: 'Program *',
                      hintText: 'Select your program',
                      readOnly: true,
                      isRequired: true,
                      onTap: () => _showBottomSheet(
                        title: 'Select Program',
                        items: programs,
                        controller: _studentProgram,
                      ),
                      validationLabel: 'Program',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _studentBatchName,
                      label: 'Batch *',
                      hintText: 'Enter your batch',
                      isRequired: true,
                      validationLabel: 'Batch',
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _studentId,
                      label: 'Student ID *',
                      hintText: 'Enter your university ID',
                      isRequired: true,
                      validationLabel: 'Student ID',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSectionCard(
                  title: "Submission & Export",
                  icon: Icons.calendar_today_rounded,
                  children: [
                    CustomTextField(
                      controller: _submissionDate,
                      label: 'Submission Date *',
                      hintText: 'Pick the submission date',
                      isRequired: true,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
                          setState(() {
                            _submissionDate.text = formattedDate;
                          });
                        }
                      },
                      validationLabel: 'Submission date',
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<SaveAsImageSelectionCubit, bool>(
                      builder: (context, state) {
                        return SelectableTile(
                          title: "Save cover as image",
                          subtitle: "Export JPG along with the generated PDF",
                          isSelected: state,
                          onTap: () => context.read<SaveAsImageSelectionCubit>().toggle(),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                BlocBuilder<TemplateSelectionCubit, int>(
                  builder: (context, templateId) {
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CityUColors.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: CityUColors.primaryRed.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                          // Save local student input data
                          _saveStudentData();

                          // Validate the form
                          if (_formKey.currentState!.validate()) {
                            try {
                              int activeTemplateId = templateId > 0 ? templateId : 1;
                              dynamic pdfData;

                              if (activeTemplateId == 1) {
                                pdfData = await Template1Pdf.generate(
                                  coverPageType: _coverPageType.text,
                                  assignmentTitle: _assignmentName.text,
                                  experimentNo: _experimentNo.text,
                                  experimentTitle: _experimentName.text,
                                  courseCode: _courseCode.text,
                                  courseTitle: _courseName.text,
                                  facultyName: _facultyName.text,
                                  facultyDesignation: _facultyDesignation.text,
                                  facultyDepartment: _facultyDepartment.text,
                                  studentName: _studentName.text,
                                  studentDepartment: _studentDepartment.text,
                                  studentProgram: _studentProgram.text,
                                  studentBatch: _studentBatchName.text,
                                  studentId: _studentId.text,
                                  submissionDate: _submissionDate.text,
                                );
                              } else if (activeTemplateId == 2) {
                                pdfData = await Template2Pdf.generate(
                                  coverPageType: _coverPageType.text,
                                  assignmentTitle: _assignmentName.text,
                                  experimentNo: _experimentNo.text,
                                  experimentTitle: _experimentName.text,
                                  courseCode: _courseCode.text,
                                  courseTitle: _courseName.text,
                                  facultyName: _facultyName.text,
                                  facultyDesignation: _facultyDesignation.text,
                                  facultyDepartment: _facultyDepartment.text,
                                  studentName: _studentName.text,
                                  studentDepartment: _studentDepartment.text,
                                  studentProgram: _studentProgram.text,
                                  studentBatch: _studentBatchName.text,
                                  studentId: _studentId.text,
                                  submissionDate: _submissionDate.text,
                                );
                              } else if (activeTemplateId == 3) {
                                pdfData = await Template3Pdf.generate(
                                  coverPageType: _coverPageType.text,
                                  assignmentTitle: _assignmentName.text,
                                  experimentNo: _experimentNo.text,
                                  experimentTitle: _experimentName.text,
                                  courseCode: _courseCode.text,
                                  courseTitle: _courseName.text,
                                  facultyName: _facultyName.text,
                                  facultyDesignation: _facultyDesignation.text,
                                  facultyDepartment: _facultyDepartment.text,
                                  studentName: _studentName.text,
                                  studentDepartment: _studentDepartment.text,
                                  studentProgram: _studentProgram.text,
                                  studentBatch: _studentBatchName.text,
                                  studentId: _studentId.text,
                                  submissionDate: _submissionDate.text,
                                );
                              } else {
                                pdfData = await Template4Pdf.generate(
                                  coverPageType: _coverPageType.text,
                                  assignmentTitle: _assignmentName.text,
                                  experimentNo: _experimentNo.text,
                                  experimentTitle: _experimentName.text,
                                  courseCode: _courseCode.text,
                                  courseTitle: _courseName.text,
                                  facultyName: _facultyName.text,
                                  facultyDesignation: _facultyDesignation.text,
                                  facultyDepartment: _facultyDepartment.text,
                                  studentName: _studentName.text,
                                  studentDepartment: _studentDepartment.text,
                                  studentProgram: _studentProgram.text,
                                  studentBatch: _studentBatchName.text,
                                  studentId: _studentId.text,
                                  submissionDate: _submissionDate.text,
                                );
                              }

                              if (context.read<SaveAsImageSelectionCubit>().state) {
                                final savedImages = await PdfToImageService.savePdfAsImagesToGallery(pdfData);
                                for (var path in savedImages) {
                                  debugPrint("Saved to Gallery: $path");
                                }
                                MessageUtils.showToast('Your cover page has been saved to gallery!');
                              }

                              await Printing.layoutPdf(
                                onLayout: (format) async => pdfData,
                              );
                            } catch (e) {
                              debugPrint("Error generating PDF: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: Colors.red),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill up all required fields marked with *"),
                                backgroundColor: CityUColors.primaryRed,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Generate Cover Page',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.picture_as_pdf_rounded, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: CityUColors.primaryRed),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          ...children,
        ],
      ),
    );
  }
}