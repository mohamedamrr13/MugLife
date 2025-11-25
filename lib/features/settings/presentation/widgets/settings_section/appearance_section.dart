import 'package:drinks_app/features/settings/presentation/settings_screen.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:drinks_app/features/settings/presentation/widgets/theme_dialog.dart';
import 'package:drinks_app/core/utils/theme/theme_cubit.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Appearance',
      children: [
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return SettingsTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: context.read<ThemeCubit>().getThemeLabel(),
              trailing: Icon(
                context.read<ThemeCubit>().getThemeIcon(),
                color: context.primaryColor,
              ),
              onTap: () => ThemeDialog.show(context),
            );
          },
        ),
      ],
    );
  }
}

class ThemeOption extends StatelessWidget {
  final ThemeState themeState;
  final IconData icon;
  final String label;

  const ThemeOption({
    super.key,
    required this.themeState,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isSelected = state == themeState;
        return Container(
          decoration: BoxDecoration(
            color:
                isSelected
                    ? context.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: isSelected ? context.primaryColor : context.dividerColor,
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color:
                  isSelected
                      ? context.primaryColor
                      : context.secondaryTextColor,
            ),
            title: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color:
                    isSelected
                        ? context.primaryColor
                        : context.primaryTextColor,
              ),
            ),
            trailing:
                isSelected
                    ? Icon(Icons.check, color: context.primaryColor)
                    : null,
            onTap: () {
              context.read<ThemeCubit>().setTheme(themeState);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
