// lib/features/settings/presentation/widgets/settings_sections/notifications_section.dart
import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart' show CupertinoSwitch;
import 'package:flutter/material.dart';

class NotificationsSection extends StatelessWidget {
  final bool emailNotifications;
  final bool pushNotifications;
  final bool orderUpdates;
  final bool promotionalEmails;
  final Function(String key, bool value) onChanged;

  const NotificationsSection({
    super.key,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.orderUpdates,
    required this.promotionalEmails,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Notifications',
      children: [
        SettingsTile(
          icon: Icons.notifications_outlined,
          title: 'Push Notifications',
          subtitle: pushNotifications ? 'Enabled' : 'Disabled',
          trailing: CupertinoSwitch(
            value: pushNotifications,
            onChanged: (value) => onChanged('push', value),
            activeColor: context.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.email_outlined,
          title: 'Email Notifications',
          subtitle: emailNotifications ? 'Enabled' : 'Disabled',
          trailing: CupertinoSwitch(
            value: emailNotifications,
            onChanged: (value) => onChanged('email', value),
            activeColor: context.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.local_shipping_outlined,
          title: 'Order Updates',
          subtitle: orderUpdates ? 'Enabled' : 'Disabled',
          trailing: CupertinoSwitch(
            value: orderUpdates,
            onChanged: (value) => onChanged('orders', value),
            activeColor: context.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        SettingsTile(
          icon: Icons.percent_outlined,
          title: 'Promotional Emails',
          subtitle: promotionalEmails ? 'Enabled' : 'Disabled',
          trailing: CupertinoSwitch(
            value: promotionalEmails,
            onChanged: (value) => onChanged('promotional', value),
            activeColor: context.primaryColor,
          ),
        ),
      ],
    );
  }
}
