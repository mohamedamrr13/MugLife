import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.errorText,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.mainColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.grey.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.grey.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: AppTheme.errorColor.withAlpha(200),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.grey.withAlpha(50)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      validator: validator,
    );
  }
}
