import 'package:flutter/material.dart';
import 'package:println/core/theme/app_colors.dart';
import 'package:println/core/theme/app_text_styles.dart';
import 'package:println/core/utils/responsive.dart';

class FormInput extends StatefulWidget {
  const FormInput({
    required this.controller,
    required this.hint,
    required this.title,
    this.obscure = false,
    this.icon,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final String title;
  final bool obscure;
  final Icon? icon;
  final TextInputType type;
  final int? maxLines;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final ValueChanged<String>? onChanged;

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextStyles.button.copyWith(color: theme.primaryColor),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.controller,
            obscureText: _obscure,
            keyboardType: widget.type,
            maxLines: widget.obscure ? 1 : widget.maxLines,
            validator: widget.validator,
            onSaved: widget.onSaved,
            onChanged: widget.onChanged,
            style: AppTextStyles.body1.copyWith(
              color: theme.textTheme.bodyLarge!.color,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.body2.copyWith(
                color: theme.textTheme.bodyMedium!.color,
              ),
              prefixIcon: widget.icon != null
                  ? Icon(widget.icon!.icon, color: theme.textTheme.bodyMedium!.color)
                  : null,
              filled: true,
              fillColor: theme.inputDecorationTheme.fillColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.danger, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.danger, width: 2),
              ),
              suffixIcon: widget.obscure
                  ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: theme.primaryColor,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}