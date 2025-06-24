import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomPageIndicatorWidget extends StatelessWidget {
  const CustomPageIndicatorWidget({
    super.key,
    required this.currentIndex,
    required this.listLength,
  });
  final double currentIndex;
  final int listLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        listLength,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex.round() == index ? 36 : 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                currentIndex.round() == index
                    ? AppColors.mainColor
                    : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
