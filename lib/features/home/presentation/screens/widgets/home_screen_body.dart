import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withAlpha(22),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.grey.withAlpha(100),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.grey.withAlpha(22)),
                  borderRadius: BorderRadius.circular(12),
                ),

                focusColor: AppColors.paymentPageMainColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Categories",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.black.withAlpha(200),
            ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffFEF9E4),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  width: 150,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          "assets/images/listviewimg.png",
                          height: 110,
                        ),
                      ),
                      Text(
                        "Shakes",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.paymentPageMainColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "50 mixes",
                        style: TextStyle(
                          color: Color(0xffFB7D8A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
