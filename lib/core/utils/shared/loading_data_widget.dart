import 'package:drinks_app/core/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingDataWidget extends StatelessWidget {
  const LoadingDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 45,
        width: 45,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
