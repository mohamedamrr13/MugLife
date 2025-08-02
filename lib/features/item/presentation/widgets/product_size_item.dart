import 'package:drinks_app/utils/colors/app_colors.dart';
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
              color: isSelected ? AppColors.mainColor : Colors.grey[100],
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: AppColors.mainColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
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
                  color: isSelected ? AppColors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            sizeNames[index],
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.mainColor : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
