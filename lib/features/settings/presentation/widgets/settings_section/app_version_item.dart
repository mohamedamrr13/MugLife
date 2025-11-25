// lib/features/settings/presentation/widgets/app_version_info.dart
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class AppVersionInfo extends StatelessWidget {
  final String appVersion;

  const AppVersionInfo({super.key, required this.appVersion});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
