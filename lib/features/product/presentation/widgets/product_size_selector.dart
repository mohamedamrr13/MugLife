// Size Selector Widget Class
import 'package:drinks_app/features/product/presentation/widgets/product_size_item.dart';
import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSizeSelected;

  const SizeSelector({
    super.key,
    required this.selectedIndex,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) => SizeSelectorItem(
            index: index,
            isSelected: selectedIndex == index,
            onTap: () => onSizeSelected(index),
          ),
        ),
      ),
    );
  }
}
