// Replace lib/features/settings/presentation.dart with this
// Save as lib/features/settings/presentation/settings_screen.dart

import 'package:drinks_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/settings_tile.dart';

import 'package:drinks_app/utils/theme/theme_cubit.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/cupertino.dart' show CupertinoSwitch;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String appVersion = '1.0.0';
  bool notificationsEnabled = true;
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool orderUpdates = true;
  bool promotionalEmails = false;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    // TODO: Uncomment when package_info_plus is added
    // final packageInfo = await PackageInfo.fromPlatform();
    // setState(() {
    //   appVersion = packageInfo.version;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    context.primaryColor,
                    context.primaryColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Text(
                  'Settings',
                  style: context.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appearance Section
                  SettingsSection(
                    title: 'Appearance',
                    children: [
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return SettingsTile(
                            icon: Icons.palette_outlined,
                            title: 'Theme',
                            subtitle:
                                context.read<ThemeCubit>().getThemeLabel(),
                            trailing: Icon(
                              context.read<ThemeCubit>().getThemeIcon(),
                              color: context.primaryColor,
                            ),
                            onTap: () {
                              _showThemeDialog(context);
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Notifications Section
                  SettingsSection(
                    title: 'Notifications',
                    children: [
                      SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Push Notifications',
                        subtitle: pushNotifications ? 'Enabled' : 'Disabled',
                        trailing: CupertinoSwitch(
                          value: pushNotifications,
                          onChanged: (value) {
                            setState(() {
                              pushNotifications = value;
                            });
                            // TODO: Update in Firebase
                          },
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
                          onChanged: (value) {
                            setState(() {
                              emailNotifications = value;
                            });
                            // TODO: Update in Firebase
                          },
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
                          onChanged: (value) {
                            setState(() {
                              orderUpdates = value;
                            });
                            // TODO: Update in Firebase
                          },
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
                          onChanged: (value) {
                            setState(() {
                              promotionalEmails = value;
                            });
                            // TODO: Update in Firebase
                          },
                          activeColor: context.primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Account Section
                  SettingsSection(
                    title: 'Account',
                    children: [
                      SettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Change Password',
                        subtitle: 'Update your password',
                        onTap: () {
                          // TODO: Navigate to change password
                          _showComingSoonDialog(context, 'Change Password');
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.payment_outlined,
                        title: 'Payment Methods',
                        subtitle: 'Manage your payment options',
                        onTap: () {
                          // TODO: Navigate to payment methods
                          _showComingSoonDialog(context, 'Payment Methods');
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.location_on_outlined,
                        title: 'Addresses',
                        subtitle: 'Manage delivery addresses',
                        onTap: () {
                          // TODO: Navigate to addresses
                          _showComingSoonDialog(context, 'Addresses');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Support Section
                  SettingsSection(
                    title: 'Support',
                    children: [
                      SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        onTap: () {
                          // TODO: Navigate to help center
                          _showComingSoonDialog(context, 'Help Center');
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.mail_outline,
                        title: 'Contact Us',
                        subtitle: 'Send us a message',
                        onTap: () {
                          _launchEmail(context);
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.star_outline,
                        title: 'Rate App',
                        subtitle: 'Share your feedback',
                        onTap: () {
                          // TODO: Open app store rating
                          _showComingSoonDialog(context, 'Rate App');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Legal Section
                  SettingsSection(
                    title: 'Legal',
                    children: [
                      SettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        subtitle: 'Read our terms',
                        onTap: () {
                          // TODO: Navigate to terms
                          _showComingSoonDialog(context, 'Terms of Service');
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        onTap: () {
                          // TODO: Navigate to privacy policy
                          _showComingSoonDialog(context, 'Privacy Policy');
                        },
                      ),
                      const SizedBox(height: 12),
                      SettingsTile(
                        icon: Icons.gavel_outlined,
                        title: 'Licenses',
                        subtitle: 'Open source licenses',
                        onTap: () {
                          showLicensePage(context: context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Danger Zone
                  SettingsSection(
                    title: 'Danger Zone',
                    children: [
                      SettingsTile(
                        icon: Icons.delete_outline,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        titleColor: Colors.red,
                        iconColor: Colors.red,
                        onTap: () {
                          _showDeleteAccountDialog(context);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // App Version
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'MugLife',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version $appVersion',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: context.read<ThemeCubit>(),
          child: AlertDialog(
            title: const Text('Choose Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  dialogContext,
                  ThemeState.light,
                  Icons.light_mode,
                  'Light',
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  dialogContext,
                  ThemeState.dark,
                  Icons.dark_mode,
                  'Dark',
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  dialogContext,
                  ThemeState.system,
                  Icons.brightness_auto,
                  'System',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    ThemeState themeState,
    IconData icon,
    String label,
  ) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isSelected = state == themeState;
        return Container(
          decoration: BoxDecoration(
            color:
                isSelected
                    ? context.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
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
              context.read<ThemeCubit>().emit(themeState);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 8),
              const Text('Delete Account'),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // TODO: Implement account deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Account deletion not yet implemented'),
                    backgroundColor: context.errorColor,
                  ),
                );
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(feature),
          content: Text('$feature will be available in a future update.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _launchEmail(BuildContext context) {
    // TODO: Uncomment when url_launcher is added
    // final Uri emailUri = Uri(
    //   scheme: 'mailto',
    //   path: 'support@muglife.com',
    //   query: 'subject=Support Request',
    // );
    //
    // if (await canLaunchUrl(emailUri)) {
    //   await launchUrl(emailUri);
    // } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Email: support@muglife.com'),
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // TODO: Copy email to clipboard
          },
        ),
      ),
    );
    // }
  }
}
