import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SizeSelectorItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const SizeSelectorItem({
    super.key,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sizes = ["S", "M", "L"];
    final sizeNames = ["Small", "Medium", "Large"];

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isSelected ? 55 : 50,
            width: isSelected ? 55 : 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isSelected
                      ? context.primaryColor
                      : context.isDark
                      ? context.cardColor.withOpacity(0.6)
                      : Colors.grey[100],
              border:
                  context.isDark && !isSelected
                      ? Border.all(
                        color: context.dividerColor.withOpacity(0.3),
                        width: 0.5,
                      )
                      : null,
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: context.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : context.isDark
                      ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: Center(
              child: Text(
                sizes[index],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      isSelected
                          ? Colors.white
                          : context.isDark
                          ? context.primaryTextColor
                          : Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sizeNames[index],
            style: TextStyle(
              fontSize: 12,
              color:
                  isSelected
                      ? context.primaryColor
                      : context.isDark
                      ? context.secondaryTextColor
                      : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

