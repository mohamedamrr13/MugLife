import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? loadingColor;
  final double borderRadius;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.loadingColor,
    this.borderRadius = 16,
    this.icon,
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor = backgroundColor ?? context.primaryColor;
    final buttonForegroundColor = foregroundColor ?? Colors.white;
    final buttonLoadingColor = loadingColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child:
          icon != null
              ? ElevatedButton.icon(
                onPressed: isLoading ? null : onPressed,
                icon:
                    isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: buttonLoadingColor,
                          ),
                        )
                        : icon!,
                label: Text(
                  text,
                  style: context.textTheme.labelLarge?.copyWith(
                    color:
                        onPressed != null
                            ? buttonForegroundColor
                            : context.secondaryTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      onPressed != null
                          ? buttonBackgroundColor
                          : context.surfaceColor,
                  foregroundColor: buttonForegroundColor,
                  elevation: elevation ?? 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    side:
                        onPressed == null
                            ? BorderSide(color: context.dividerColor)
                            : BorderSide.none,
                  ),
                  padding:
                      padding ??
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      onPressed != null
                          ? buttonBackgroundColor
                          : context.surfaceColor,
                  foregroundColor: buttonForegroundColor,
                  elevation: elevation ?? 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    side:
                        onPressed == null
                            ? BorderSide(color: context.dividerColor)
                            : BorderSide.none,
                  ),
                  padding:
                      padding ??
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child:
                    isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: buttonLoadingColor,
                          ),
                        )
                        : Text(
                          text,
                          style: context.textTheme.labelLarge?.copyWith(
                            color:
                                onPressed != null
                                    ? buttonForegroundColor
                                    : context.secondaryTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
              ),
    );
  }
}
