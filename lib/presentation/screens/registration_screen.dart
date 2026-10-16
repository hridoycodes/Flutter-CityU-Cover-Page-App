import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cityu_cover_page/presentation/screens/choose_template_screen.dart';

class CityUColors {
  static const Color primaryRed = Color(0xFF8B0000);
  static const Color lightBackground = Color(0xFFF8F9FA);
}

class RegistrationScreen extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (_) => const RegistrationScreen());
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Modes: 0 = Login, 1 = Signup, 2 = Forgot Password
  int _authMode = 0;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (_authMode == 1) {
        // Signup Mode: Save credentials and set logged in state
        await prefs.setBool('is_registered', true);
        await prefs.setString('user_email', email);
        await prefs.setString('user_password', password);
        await prefs.setBool('is_logged_in', true);

        if (!mounted) return;
        Navigator.pushReplacement(context, ChooseTemplateScreen.route());
      } else if (_authMode == 0) {
        // Login Mode: Verify credentials
        String? savedEmail = prefs.getString('user_email');
        String? savedPassword = prefs.getString('user_password');

        if (savedEmail == email && savedPassword == password) {
          await prefs.setBool('is_logged_in', true);
          if (!mounted) return;
          Navigator.pushReplacement(context, ChooseTemplateScreen.route());
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password!"), backgroundColor: Colors.red),
          );
        }
      } else if (_authMode == 2) {
        // Forgot Password Mode: Reset password for existing email
        String? savedEmail = prefs.getString('user_email');

        if (savedEmail == email) {
          await prefs.setString('user_password', password);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password reset successfully! Please login."), backgroundColor: Colors.green),
          );
          setState(() {
            _authMode = 0;
            _passwordController.clear();
          });
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email not found!"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String titleText = _authMode == 1 ? "Create Account" : (_authMode == 0 ? "Welcome Back" : "Reset Password");
    String subtitleText = _authMode == 1
        ? "Sign up to get started with CityU Cover Page"
        : (_authMode == 0 ? "Login to your CityU account" : "Enter your email and new password");

    return Scaffold(
      backgroundColor: CityUColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CityUColors.primaryRed.withOpacity(0.12),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.asset(
                            "assets/images/logo.jpg",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              "assets/images/cityu_logo.jpg",
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: CityUColors.primaryRed.withOpacity(0.1),
                                child: const Icon(Icons.school, size: 34, color: CityUColors.primaryRed),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          titleText,
                          key: ValueKey<String>(titleText),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: CityUColors.primaryRed),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(child: Text(subtitleText, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 13))),
                    const SizedBox(height: 24),

                    // Email Field with Title
                    const Text(
                      "Email / Username",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your email or username",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14), // Updated to grey
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(Icons.email_outlined, color: CityUColors.primaryRed),
                      ),
                      validator: (value) => value!.isEmpty ? "Please enter email" : null,
                    ),
                    const SizedBox(height: 16),

                    // Password Field with Title
                    Text(
                      _authMode == 2 ? "New Password" : "Password",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14), // Updated to grey
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        prefixIcon: const Icon(Icons.lock_outline, color: CityUColors.primaryRed),
                      ),
                      validator: (value) => value!.length < 6 ? "Minimum 6 characters required" : null,
                    ),

                    if (_authMode == 0)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => _authMode = 2),
                          child: const Text("Forgot Password?", style: TextStyle(color: CityUColors.primaryRed, fontWeight: FontWeight.w600)),
                        ),
                      )
                    else
                      const SizedBox(height: 16),

                    const SizedBox(height: 4),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CityUColors.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _submitForm,
                        child: Text(
                          _authMode == 1 ? "Sign Up" : (_authMode == 0 ? "Login" : "Reset Password"),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Center(
                      child: _authMode == 1
                          ? TextButton(
                        onPressed: () => setState(() => _authMode = 0),
                        child: const Text("Already have an account? Login", style: TextStyle(color: CityUColors.primaryRed)),
                      )
                          : (_authMode == 0
                          ? TextButton(
                        onPressed: () => setState(() => _authMode = 1),
                        child: const Text("Don't have an account? Sign Up", style: TextStyle(color: CityUColors.primaryRed)),
                      )
                          : TextButton(
                        onPressed: () => setState(() => _authMode = 0),
                        child: const Text("Back to Login", style: TextStyle(color: CityUColors.primaryRed)),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
