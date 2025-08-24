import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // iOS-inspired color palette
  static const Color primaryColor = Color(0xFFFF6B35); // Orange
  static const Color primaryVariant = Color(0xFFE55A2B);
  static const Color secondaryColor = Color(0xFF4A90E2); // Blue
  static const Color greenBtnColor = Color(0xff00B894);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color bgScaffoldColor = Color(0xffF4F6F9);
  static const Color paymentPageprimaryColor = Color(0xff1E2742);
  static const Color surfaceColor = Color(0xffffffff);
  static const Color errorColor = Color(0xffe53e3e);
  static const Color successColor = Color(0xff38a169);
  static const Color warningColor = Color(0xffd69e2e);
  static const Color textPrimary = Color(0xff2d3748);
  static const Color textSecondary = Color(0xff718096);
  static const Color dividerColor = Color(0xffe2e8f0);

  // Dark Theme Colors
  static const Color darkBgScaffoldColor = Color(0xff1E1E1E);
  static const Color darkSurfaceColor = Color(0xff1E1E1E);
  static const Color darkCardColor = Color(0xff2D2D2D);
  static const Color darkTextPrimary = Color(0xffE2E8F0);
  static const Color darkTextSecondary = Color(0xffA0AEC0);
  static const Color darkDividerColor = Color(0xff4A5568);
  static const Color darkprimaryColor = Color(0xff4FC3F7);

  // Shimmer Colors
  static const Color shimmerBaseColor = Color(0xffE0E0E0);
  static const Color shimmerHighlightColor = Color(0xffF5F5F5);
  static const Color darkShimmerBaseColor = Color(0xff2D2D2D);
  static const Color darkShimmerHighlightColor = Color(0xff3D3D3D);
  // Light theme colors
  static const Color lightBackground = Color(
    0xFFF2F2F7,
  ); // iOS light background
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE5E5EA);

  // Dark theme colors (iOS 13+ inspired)
  static const Color darkBackground = Color(0xFF000000); // True black for OLED
  static const Color darkSurface = Color(0xFF1C1C1E); // iOS dark surface
  static const Color darkCard = Color(0xFF2C2C2E); // iOS dark card
  static const Color darkDivider = Color(0xFF38383A);

  // Text colors
  static const Color lightPrimaryText = Color(0xFF000000);
  static const Color lightSecondaryText = Color(0xFF8E8E93);
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFF8E8E93);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: Color(0xFFFFE4DB),
        secondary: secondaryColor,
        secondaryContainer: Color(0xFFE3F2FD),
        surface: lightSurface,
        surfaceContainerHighest: Color(0xFFF2F2F7),
        surfaceContainerHigh: Color(0xFFF9F9F9),
        surfaceContainer: Color(0xFFFFFFFF),
        background: lightBackground,
        error: Color(0xFFFF3B30), // iOS red
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightPrimaryText,
        onSurfaceVariant: lightSecondaryText,
        onBackground: lightPrimaryText,
        outline: lightDivider,
        outlineVariant: Color(0xFFF2F2F7),
      ),

      // Scaffold
      scaffoldBackgroundColor: lightBackground,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightPrimaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          color: lightPrimaryText,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // Text theme (iOS-inspired)
      textTheme: const TextTheme(
        // Headlines
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: lightPrimaryText,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: lightPrimaryText,
          height: 1.2,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: lightPrimaryText,
          height: 1.2,
        ),

        // Titles
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: lightPrimaryText,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: lightPrimaryText,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: lightPrimaryText,
          height: 1.3,
        ),

        // Body text
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: lightPrimaryText,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: lightPrimaryText,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: lightSecondaryText,
          height: 1.4,
        ),

        // Labels
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: lightPrimaryText,
          height: 1.3,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: lightSecondaryText,
          height: 1.3,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: lightSecondaryText,
          height: 1.3,
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 0.5,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: lightPrimaryText, size: 24),

      // Bottom navigation bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: lightSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        primaryContainer: Color(0xFF4A2C1A),
        secondary: secondaryColor,
        secondaryContainer: Color(0xFF1E3A5F),
        surface: darkSurface,
        surfaceContainerHighest: darkCard,
        surfaceContainerHigh: Color(0xFF2C2C2E),
        surfaceContainer: darkSurface,
        background: darkBackground,
        error: Color(0xFFFF453A), // iOS dark red
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: darkPrimaryText,
        onSurfaceVariant: darkSecondaryText,
        onBackground: darkPrimaryText,
        outline: darkDivider,
        outlineVariant: Color(0xFF2C2C2E),
      ),

      // Scaffold
      scaffoldBackgroundColor: darkBackground,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkPrimaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          color: darkPrimaryText,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'SF Pro Display',
        ),
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),

      // Text theme (iOS-inspired dark)
      textTheme: const TextTheme(
        // Headlines
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: darkPrimaryText,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: darkPrimaryText,
          height: 1.2,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: darkPrimaryText,
          height: 1.2,
        ),

        // Titles
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkPrimaryText,
          height: 1.3,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: darkPrimaryText,
          height: 1.3,
        ),
        titleSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkPrimaryText,
          height: 1.3,
        ),

        // Body text
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: darkPrimaryText,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: darkPrimaryText,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: darkSecondaryText,
          height: 1.4,
        ),

        // Labels
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: darkPrimaryText,
          height: 1.3,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: darkSecondaryText,
          height: 1.3,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: darkSecondaryText,
          height: 1.3,
        ),
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 0.5,
        space: 1,
      ),

      // Icon theme
      iconTheme: const IconThemeData(color: darkPrimaryText, size: 24),

      // Bottom navigation bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkSecondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
