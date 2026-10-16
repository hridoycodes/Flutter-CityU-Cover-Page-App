import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cityu_cover_page/presentation/screens/choose_template_screen.dart';
import 'package:cityu_cover_page/presentation/screens/registration_screen.dart';

// City University Brand Red Colors
class CityUColors {
  static const Color primaryRed = Color(0xFF8B0000); // Deep Crimson Red
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Ripple / Pulse animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Ensure splash renders fully before triggering navigation delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateScreen();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateScreen() async {
    // Guaranteed delay so splash screen is always visible properly
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;

    // Direct SharedPreferences check inside Splash Screen
    final prefs = await SharedPreferences.getInstance();
    bool isRegistered = prefs.getBool('is_registered') ?? false;
    bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    if (!isRegistered || !isLoggedIn) {
      // First time or logged out -> Go to Registration Screen
      Navigator.pushReplacement(
        context,
        RegistrationScreen.route(),
      );
    } else {
      // Already registered and logged in -> Go directly to Template Screen
      Navigator.pushReplacement(
        context,
        ChooseTemplateScreen.route(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: SafeArea(
        child: Stack(
          children: [
            // Center content with ripple scale animation
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // App Logo with dual path fallback and soft shadow
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: CityUColors.primaryRed.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image.asset(
                                "assets/images/logo.jpg",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Image.asset(
                                  "assets/images/cityu_logo.jpg",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: CityUColors.primaryRed.withOpacity(0.1),
                                    child: const Icon(
                                      Icons.school,
                                      size: 50,
                                      color: CityUColors.primaryRed,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // App Name below logo
                          const Text(
                            "CityU Cover Page",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Credit Text
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: const Text(
                "Made with love by Hridoy",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black45,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
