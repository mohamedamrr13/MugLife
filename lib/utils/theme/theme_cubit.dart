import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeState { light, dark, system }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.system) {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  void _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to system

      switch (themeIndex) {
        case 0:
          emit(ThemeState.light);
          break;
        case 1:
          emit(ThemeState.dark);
          break;
        case 2:
        default:
          emit(ThemeState.system);
          break;
      }
    } catch (e) {
      emit(ThemeState.system);
    }
  }

  // New method to set a specific theme
  Future<void> setTheme(ThemeState themeState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeState.index);
      emit(themeState);
    } catch (e) {
      emit(themeState);
    }
  }

  void toggleTheme() async {
    try {
      ThemeState newTheme;
      switch (state) {
        case ThemeState.light:
          newTheme = ThemeState.dark;
          break;
        case ThemeState.dark:
          newTheme = ThemeState.system;
          break;
        case ThemeState.system:
          newTheme = ThemeState.light;
          break;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, newTheme.index);
      emit(newTheme);
    } catch (e) {
      // Fallback toggle without persistence
      ThemeState newTheme;
      switch (state) {
        case ThemeState.light:
          newTheme = ThemeState.dark;
          break;
        case ThemeState.dark:
          newTheme = ThemeState.system;
          break;
        case ThemeState.system:
          newTheme = ThemeState.light;
          break;
      }
      emit(newTheme);
    }
  }

  ThemeMode getThemeMode() {
    switch (state) {
      case ThemeState.light:
        return ThemeMode.light;
      case ThemeState.dark:
        return ThemeMode.dark;
      case ThemeState.system:
        return ThemeMode.system;
    }
  }

  String getThemeLabel() {
    switch (state) {
      case ThemeState.light:
        return "Light Mode";
      case ThemeState.dark:
        return "Dark Mode";
      case ThemeState.system:
        return "System Mode";
    }
  }

  IconData getThemeIcon() {
    switch (state) {
      case ThemeState.light:
        return Icons.light_mode;
      case ThemeState.dark:
        return Icons.dark_mode;
      case ThemeState.system:
        return Icons.brightness_auto;
    }
  }

  bool get isDark => state == ThemeState.dark;
  bool get isLight => state == ThemeState.light;
  bool get isSystem => state == ThemeState.system;
}
