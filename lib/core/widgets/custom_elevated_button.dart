import 'package:flutter/material.dart';
import 'package:cityu_cover_page/core/themes/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.transparent,
                shadowColor: AppColors.transparent,
              ),
              child: Text(label),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.transparent,
                shadowColor: AppColors.transparent,
              ),
              label: Text(label),
              icon: Icon(icon, size: 18),
              iconAlignment: IconAlignment.end,
            ),
    );
  }
}
