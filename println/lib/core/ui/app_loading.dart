import "package:flutter/material.dart";
import "package:println/core/theme/app_spacing.dart";

class AppLoading {
  static void show(BuildContext context, {String message = "Carregando..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        final theme = Theme.of(context);

        return Dialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}