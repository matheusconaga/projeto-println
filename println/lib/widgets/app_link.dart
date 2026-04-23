import 'package:flutter/material.dart';
import 'package:println/core/theme/app_text_styles.dart';

class AppLink extends StatelessWidget {
  const AppLink({required this.title, required this.func, super.key});

  final String title;
  final void Function() func;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: func,
      child: Text(
        title,
        style: AppTextStyles.button.copyWith(
          color: theme.primaryColor,
        ),
      ),
    );
  }
}