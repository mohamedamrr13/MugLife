import 'package:drinks_app/features/settings/presentation/widgets/dialog_helpers.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

class SupportSection extends StatelessWidget {
  final VoidCallback onContactUs;

  const SupportSection({super.key, required this.onContactUs});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Support',
      children: [
        SettingsTile(
          icon: Icons.help_outline,
          title: 'Help Center',
          subtitle: 'Get help and support',
          onTap:
              () => DialogHelpers.showComingSoonDialog(context, 'Help Center'),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.mail_outline,
          title: 'Contact Us',
          subtitle: 'Send us a message',
          onTap: onContactUs,
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.star_outline,
          title: 'Rate App',
          subtitle: 'Share your feedback',
          onTap: () => DialogHelpers.showComingSoonDialog(context, 'Rate App'),
        ),
      ],
    );
  }
}
