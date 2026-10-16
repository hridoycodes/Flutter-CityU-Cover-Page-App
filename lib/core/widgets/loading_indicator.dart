import 'package:flutter/cupertino.dart';
import 'package:cityu_cover_page/core/themes/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 32,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: CupertinoActivityIndicator(
          color: color ?? AppColors.white,
          radius: size / 2.5,
        ),
      ),
    );
  }
}
