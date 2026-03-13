import 'package:flutter/material.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    required this.onPressed,
    this.image,
    this.primary = true,
    super.key,
  });

  final String title;
  final void Function() onPressed;
  final String? image;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary ? theme.primaryColor : LightColors.surface,
          foregroundColor: primary ? LightColors.surface : theme.primaryColor,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: primary ? BorderSide.none : BorderSide(color: theme.primaryColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null) ...[
              Image.asset(image!, width: 24, height: 24),
              const SizedBox(width: 8),
            ],
            Text(title, style: AppTextStyles.button),
          ],
        ),
      ),
    );
  }
}