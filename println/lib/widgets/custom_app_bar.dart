import 'package:flutter/material.dart';
import 'package:println/core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationsTap;

  const CustomAppBar({super.key, required this.onNotificationsTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isDark ? Colors.black : Colors.white,
            child: Image.asset("assets/logo.png"),
          ),
          const SizedBox(width: 8),
          Text(
            "PrintLn",
            style: AppTextStyles.heading1.copyWith(color: Colors.white),
          ),
        ],
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: onNotificationsTap,
        ),
      ],
    );
  }
}