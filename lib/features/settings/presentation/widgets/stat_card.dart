// lib/features/settings/widgets/stat_card.dart
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color:
                context.isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.primaryTextColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
