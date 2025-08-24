import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class GoogleSignButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? customIcon;

  const GoogleSignButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius = 16,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon:
            isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: context.primaryColor,
                  ),
                )
                : customIcon ??
                    Image.asset(
                      'assets/icons/IconGoogle.png',
                      height: 20,
                      width: 20,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon if asset is not found
                        return Icon(
                          Icons.g_mobiledata,
                          color: context.primaryColor,
                          size: 24,
                        );
                      },
                    ),
        label:
            isLoading
                ? const SizedBox.shrink()
                : Text(
                  text,
                  style: context.textTheme.labelLarge?.copyWith(
                    color:
                        onPressed != null
                            ? context.primaryTextColor
                            : context.secondaryTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              onPressed != null
                  ? context.surfaceColor
                  : context.surfaceColor.withOpacity(0.5),
          foregroundColor: context.primaryTextColor,
          side: BorderSide(
            width: 1.5,
            color:
                onPressed != null
                    ? context.dividerColor
                    : context.dividerColor.withOpacity(0.5),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 0,
        ),
      ),
    );
  }
}
