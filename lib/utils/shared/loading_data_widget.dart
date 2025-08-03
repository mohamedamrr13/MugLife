import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingDataWidget extends StatelessWidget {
  const LoadingDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          height: 50,
          width: 50,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.mainColor,
          ),
        ),
      ),
    );
  }
}
