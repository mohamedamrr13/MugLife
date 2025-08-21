import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAuthAppbar extends StatelessWidget {
  const CustomAuthAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 80),
        Text(
          "M u g L i f e",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
