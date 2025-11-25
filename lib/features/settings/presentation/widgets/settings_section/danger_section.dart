// lib/features/settings/presentation/widgets/settings_sections/danger_zone_section.dart
import 'package:drinks_app/features/settings/presentation/widgets/dialog_helpers.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Danger Zone',
      children: [
        SettingsTile(
          icon: Icons.delete_outline,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          titleColor: Colors.red,
          iconColor: Colors.red,
          onTap: () {
            DialogHelpers.showConfirmationDialog(
              context: context,
              title: 'Delete Account',
              content:
                  'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
              confirmText: 'Delete',
              confirmColor: Colors.red,
              icon: Icons.warning_amber_rounded,
              onConfirm: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Account deletion not yet implemented'),
                    backgroundColor: context.errorColor,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
