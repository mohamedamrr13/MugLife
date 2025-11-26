import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SaveAddressCheckbox extends StatelessWidget {
  const SaveAddressCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color:
                context.isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
            blurRadius: context.isDark ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: (newValue) {
                onChanged(newValue ?? false);
              },
              activeColor: context.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Save this address for future orders',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
