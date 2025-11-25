// lib/features/settings/presentation/widgets/theme_dialog.dart
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/appearance_section.dart';
import 'package:drinks_app/core/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeDialog extends StatelessWidget {
  const ThemeDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<ThemeCubit>(),
          child: const ThemeDialog(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Theme'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ThemeOption(
            themeState: ThemeState.light,
            icon: Icons.light_mode,
            label: 'Light',
          ),
          const SizedBox(height: 8),
          ThemeOption(
            themeState: ThemeState.dark,
            icon: Icons.dark_mode,
            label: 'Dark',
          ),
          const SizedBox(height: 8),
          ThemeOption(
            themeState: ThemeState.system,
            icon: Icons.brightness_auto,
            label: 'System',
          ),
        ],
      ),
    );
  }
}
