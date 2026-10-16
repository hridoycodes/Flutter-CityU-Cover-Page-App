import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cityu_cover_page/core/utils/message_utils.dart';
import 'package:cityu_cover_page/data/models/template.dart';
import 'package:cityu_cover_page/presentation/cubit/template_selection_cubit.dart';
import 'package:cityu_cover_page/presentation/screens/fields_screen.dart';
import 'package:cityu_cover_page/presentation/screens/registration_screen.dart';

// City University Brand Red Colors
class CityUColors {
  static const Color primaryRed = Color(0xFF8B0000); // Deep Crimson Red
  static const Color brightRed = Color(0xFFD32F2F);  // Accent Red
  static const Color lightRed = Color(0xFFFFEBEE);   // Soft Background Tint
  static const Color cardBorder = Color(0xFFE0E0E0);
}

class ChooseTemplateScreen extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const ChooseTemplateScreen());

  const ChooseTemplateScreen({super.key});

  // Cached template list for high performance
  static final List<Template> _templates = [
    Template(1, "Minimal", "assets/images/template1.png"),
    Template(2, "Modern", "assets/images/template2.png"),
    Template(3, "Classic", "assets/images/template3.png"),
    Template(4, "Creative", "assets/images/template4.png"),
  ];

  // Handle User Logout
  void _handleLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false); // Clear login session state

    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Row(
          children: [
            // App Logo with dual path fallback on AppBar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/cityu_logo.jpg',
                  height: 32,
                  width: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "CityU Cover Page",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: CityUColors.primaryRed,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Navigation Drawer with dual path fallback logo
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: CityUColors.primaryRed,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/cityu_logo.jpg',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, color: CityUColors.primaryRed, size: 30),
                    ),
                  ),
                ),
              ),
              accountName: const Text(
                "CityU Student",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text(
                "City University Bangladesh",
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined, color: CityUColors.primaryRed),
              title: const Text("Templates", style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text("Log Out", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _handleLogout(context); // Trigger logout and redirect to Registration
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header description
              const Text(
                "Select a Template",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Tap to choose, long press to preview full layout.",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),

              // Optimized template grid view
              Expanded(
                child: BlocBuilder<TemplateSelectionCubit, int>(
                  buildWhen: (previous, current) => previous != current,
                  builder: (context, selectedId) {
                    return GridView.builder(
                      itemCount: _templates.length,
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.62,
                      ),
                      itemBuilder: (context, index) {
                        final template = _templates[index];
                        final isSelected = selectedId == template.id;

                        // RepaintBoundary isolates card repainting for speed
                        return RepaintBoundary(
                          child: TemplateCard(
                            template: template,
                            isSelected: isSelected,
                            onTap: () {
                              context.read<TemplateSelectionCubit>().selectTemplate(template.id);
                            },
                            onLongPress: () => _showPreviewDialog(context, template),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // Bottom continue action button with proper validation feedback
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: BlocBuilder<TemplateSelectionCubit, int>(
                  builder: (context, selectedId) {
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
                        onPressed: () {
                          if (selectedId > 0) {
                            Navigator.push(context, FieldsScreen.route());
                          } else {
                            // Show explicit error message if no template is selected
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select a template to proceed."),
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
                              'Continue',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show image preview dialog on long press
  void _showPreviewDialog(BuildContext context, Template template) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                template.image,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Highly optimized template card widget
class TemplateCard extends StatelessWidget {
  final Template template;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const TemplateCard({
    super.key,
    required this.template,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      transform: Matrix4.identity()..scale(isSelected ? 1.02 : 1.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? CityUColors.primaryRed : Colors.grey.shade200,
          width: isSelected ? 2.5 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? CityUColors.primaryRed.withOpacity(0.25)
                : Colors.black.withOpacity(0.03),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      // Template image container
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              template.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Template title
                      Text(
                        template.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? CityUColors.primaryRed : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
                // Floating selection check badge
                Positioned(
                  top: 14,
                  right: 14,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isSelected ? CityUColors.primaryRed : Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isSelected ? Icons.check : Icons.circle_outlined,
                      size: 14,
                      color: isSelected ? Colors.white : Colors.grey.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}