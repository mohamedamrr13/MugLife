import 'package:drinks_app/features/settings/presentation/widgets/gradient_appbar.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/account_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/app_version_item.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/appearance_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/danger_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/legal_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/notification_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_section/support_section.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = '1.0.0';
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool orderUpdates = true;
  bool promotionalEmails = false;

  @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

  Future<void> loadAppVersion() async {
    // final packageInfo = await PackageInfo.fromPlatform();
    // setState(() {
    //   appVersion = packageInfo.version;
    // });
  }

  void updateNotificationSetting(String key, bool value) {
    setState(() {
      switch (key) {
        case 'email':
          emailNotifications = value;
          break;
        case 'push':
          pushNotifications = value;
          break;
        case 'orders':
          orderUpdates = value;
          break;
        case 'promotional':
          promotionalEmails = value;
          break;
      }
    });
  }

  void launchEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email: support@muglife.com'),
        action: SnackBarAction(label: 'Copy', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const GradientAppBar(title: 'Settings'),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppearanceSection(),
                  const SizedBox(height: 24),
                  NotificationsSection(
                    emailNotifications: emailNotifications,
                    pushNotifications: pushNotifications,
                    orderUpdates: orderUpdates,
                    promotionalEmails: promotionalEmails,
                    onChanged: updateNotificationSetting,
                  ),
                  const SizedBox(height: 24),
                  const AccountSection(),
                  const SizedBox(height: 24),
                  SupportSection(onContactUs: launchEmail),
                  const SizedBox(height: 24),
                  const LegalSection(),
                  const SizedBox(height: 24),
                  const DangerZoneSection(),
                  const SizedBox(height: 32),
                  AppVersionInfo(appVersion: appVersion),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
