import 'package:flutter/material.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/theme/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.onBackTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(

      elevation: 0,
      leading: onBackTap != null
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackTap,
      )
          : null,
      title: title != null
          ? Text(title!, style: AppTextStyles.heading1.copyWith(color: Colors.white))
          : Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isDark ? DarkColors.inputFill : LightColors.inputFill,
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
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Atenção"),
                  content: const Text("Funcionalidade ainda não implementada."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}