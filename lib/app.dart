import 'package:flutter/material.dart';
import 'package:cityu_cover_page/core/themes/app_theme.dart';
import 'package:cityu_cover_page/presentation/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CityU Cover Page',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
