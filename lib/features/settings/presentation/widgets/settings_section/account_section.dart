// lib/features/settings/presentation/widgets/settings_sections/account_section.dart
import 'package:drinks_app/features/settings/presentation/widgets/dialog_helpers.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Account',
      children: [
        SettingsTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          subtitle: 'Update your password',
          onTap:
              () => DialogHelpers.showComingSoonDialog(
                context,
                'Change Password',
              ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.payment_outlined,
          title: 'Payment Methods',
          subtitle: 'Manage your payment options',
          onTap:
              () => DialogHelpers.showComingSoonDialog(
                context,
                'Payment Methods',
              ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.location_on_outlined,
          title: 'Addresses',
          subtitle: 'Manage delivery addresses',
          onTap: () => DialogHelpers.showComingSoonDialog(context, 'Addresses'),
        ),
      ],
    );
  }
}
