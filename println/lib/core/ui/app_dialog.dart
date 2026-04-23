import 'package:flutter/material.dart';

class AppDialog {
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String description,
    String confirmText = "Confirmar",
    String cancelText = "Cancelar",
    Color? confirmColor,
    IconData? icon,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: iconColor ?? theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.displayMedium,
                ),
              ),
            ],
          ),
          content: Text(
            description,
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                confirmColor ?? theme.colorScheme.primary,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );
  }
}