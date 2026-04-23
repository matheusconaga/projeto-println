import 'package:flutter/material.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/ui/app_messenger.dart';

class AppSnackbar {

  static void showGlobal(
      String message, {
        Color? color,
        Duration duration = const Duration(seconds: 3),
        String? actionLabel,
        VoidCallback? onAction,
      }) {
    final messenger = AppMessenger.messengerKey.currentState;

    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: color ?? AppColors.info,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          action: actionLabel != null
              ? SnackBarAction(
            label: actionLabel,
            textColor: AppColors.accent,
            onPressed: onAction ?? () {},
          )
              : null,
        ),
      );
  }

  // helpers
  static void success(String message) {
    showGlobal(message, color: AppColors.success);
  }

  static void error(String message) {
    showGlobal(message, color: AppColors.danger);
  }

  static void info(String message) {
    showGlobal(message, color: AppColors.info);
  }
}