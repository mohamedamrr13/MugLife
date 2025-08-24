import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:flutter/material.dart';

/// Extension on ThemeData to provide easy access to app-specific colors
extension AppThemeExtension on ThemeData {
  /// Get primary color from theme
  Color get primaryColor => colorScheme.primary;

  /// Get secondary color from theme
  Color get secondaryColor => colorScheme.secondary;

  /// Get background color from theme
  Color get backgroundColor => colorScheme.background;

  /// Get scaffold background color
  Color get scaffoldBgColor =>
      brightness == Brightness.light
          ? const Color(0xFFFFFFFF) // lightBackground from AppTheme
          : const Color(0xFF1C1C1C); // darkBackground from AppTheme

  /// Get surface color from theme
  Color get surfaceColor => colorScheme.surface;

  /// Get card color from theme
  Color get cardColor => colorScheme.surfaceContainer;

  /// Get primary text color from theme
  Color get primaryTextColor => colorScheme.onSurface;

  /// Get secondary text color from theme
  Color get secondaryTextColor => colorScheme.onSurfaceVariant;

  /// Get divider color from theme
  Color get dividerColor => colorScheme.outline;

  /// Get error color from theme
  Color get errorColor => colorScheme.error;

  /// Get success color (green)
  Color get successColor =>
      brightness == Brightness.light
          ? const Color(0xff38a169)
          : const Color(0xff48bb78);

  /// Get warning color (orange/yellow)
  Color get warningColor =>
      brightness == Brightness.light
          ? const Color(0xffd69e2e)
          : const Color(0xffecc94b);

  /// Get green button color
  Color get greenBtnColor =>
      brightness == Brightness.light
          ? const Color(0xff00B894)
          : const Color(0xff00D2A0);

  /// Get payment page primary color
  Color get paymentPagePrimaryColor =>
      brightness == Brightness.light
          ? const Color(0xff1E2742)
          : const Color(0xff2A3F5F);

  /// Get shimmer base color
  Color get shimmerBaseColor =>
      brightness == Brightness.light
          ? const Color(0xffE0E0E0)
          : const Color(0xff2D2D2D);

  /// Get shimmer highlight color
  Color get shimmerHighlightColor =>
      brightness == Brightness.light
          ? const Color(0xffF5F5F5)
          : const Color(0xff3D3D3D);

  /// Check if current theme is dark
  bool get isDark => brightness == Brightness.dark;

  /// Check if current theme is light
  bool get isLight => brightness == Brightness.light;
}

/// Extension on BuildContext to easily access theme colors
extension ThemeContextExtension on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get primary color
  Color get primaryColor => AppTheme.mainColor;

  /// Get secondary color
  Color get secondaryColor => theme.secondaryColor;

  /// Get background color
  Color get backgroundColor => theme.backgroundColor;

  /// Get surface color
  Color get surfaceColor => theme.surfaceColor;

  /// Get card color
  Color get cardColor =>
      isDark ? AppTheme.mainColor.withOpacity(0.15) : AppTheme.white;

  /// Get primary text color
  Color get primaryTextColor => theme.primaryTextColor;

  /// Get secondary text color
  Color get secondaryTextColor => theme.secondaryTextColor;

  /// Get divider color
  Color get dividerColor => theme.dividerColor;

  /// Get error color
  Color get errorColor => theme.errorColor;

  /// Get success color
  Color get successColor => theme.successColor;

  /// Get warning color
  Color get warningColor => theme.warningColor;

  /// Get green button color
  Color get greenBtnColor => theme.greenBtnColor;

  /// Get payment page primary color
  Color get paymentPagePrimaryColor => theme.paymentPagePrimaryColor;

  /// Get shimmer base color
  Color get shimmerBaseColor => theme.shimmerBaseColor;

  /// Get shimmer highlight color
  Color get shimmerHighlightColor => theme.shimmerHighlightColor;

  /// Check if current theme is dark
  bool get isDark => theme.isDark;

  /// Check if current theme is light
  bool get isLight => theme.isLight;
}
