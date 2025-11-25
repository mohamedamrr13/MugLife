// lib/features/settings/presentation/widgets/settings_sections/legal_section.dart
import 'package:drinks_app/features/settings/presentation/widgets/dialog_helpers.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Legal',
      children: [
        SettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms',
          onTap:
              () => DialogHelpers.showComingSoonDialog(
                context,
                'Terms of Service',
              ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          onTap:
              () =>
                  DialogHelpers.showComingSoonDialog(context, 'Privacy Policy'),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.gavel_outlined,
          title: 'Licenses',
          subtitle: 'Open source licenses',
          onTap: () => showLicensePage(context: context),
        ),
      ],
    );
  }
}
