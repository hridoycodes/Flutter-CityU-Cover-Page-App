import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String selectedTemplateKey = 'selected_template';
  static const String studentNameKey = 'student_name';
  static const String studentDepartmentKey = 'student_department';
  static const String studentProgramKey = 'student_program';
  static const String studentBatchKey = 'student_batch';
  static const String studentIdKey = 'student_id';

  Future<void> saveSelectedTemplate(String templateId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(selectedTemplateKey, templateId);
  }

  Future<String?> getSelectedTemplate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedTemplateKey) ?? '';
  }

  Future<void> saveStudentName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentNameKey, name);
  }

  Future<String?> getStudentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentNameKey) ?? '';
  }

  Future<void> saveStudentDepartment(String department) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentDepartmentKey, department);
  }

  Future<String?> getStudentDepartment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentDepartmentKey) ?? '';
  }

  Future<void> saveStudentProgram(String program) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentProgramKey, program);
  }

  Future<String?> getStudentProgram() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentProgramKey) ?? '';
  }

  Future<void> saveStudentBatch(String batch) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentBatchKey, batch);
  }

  Future<String?> getStudentBatch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentBatchKey) ?? '';
  }

  Future<void> saveStudentId(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(studentIdKey, studentId);
  }

  Future<String?> getStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(studentIdKey) ?? '';
  }
}
