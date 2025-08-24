import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final String? errorText;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.errorText,
    this.autovalidateMode,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      enabled: enabled,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      style: context.textTheme.bodyMedium?.copyWith(
        color: enabled ? context.primaryTextColor : context.secondaryTextColor,
      ),
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.secondaryTextColor,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        suffixIconColor: context.secondaryTextColor,
        prefixIconColor: context.secondaryTextColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.dividerColor),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.errorColor),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: context.errorColor),
          borderRadius: BorderRadius.circular(16),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: context.dividerColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor:
            enabled
                ? context.surfaceColor
                : context.surfaceColor.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: context.textTheme.bodySmall?.copyWith(
          color: context.errorColor,
        ),
      ),
      validator: validator,
    );
  }
}
