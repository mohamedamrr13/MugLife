// custom_appbar.dart
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.subTitle,
    required this.prefixIcon,
    this.shadow,
    required this.color,
  });

  final String title;
  final String? subTitle;
  final Widget prefixIcon;
  final BoxShadow? shadow;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: shadow != null ? [shadow!] : null,
      ),
      child: Column(
        children: [
          SizedBox(height: 45),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -1,
                          height: 1.1,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 4),
                      subTitle == null
                          ? SizedBox.shrink()
                          : Text(
                            subTitle ?? '',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    ],
                  ),
                ),
                prefixIcon,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
