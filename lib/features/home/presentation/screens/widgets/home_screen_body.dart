import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/categoreis_list_view.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/newest_list_view.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(12),
          //       color: AppColors.white,
          //       boxShadow: [
          //         BoxShadow(
          //           color: AppColors.grey.withAlpha(22),
          //           blurRadius: 5,
          //           spreadRadius: 2,
          //         ),
          //       ],
          //     ),
          //     child: TextField(
          //       decoration: InputDecoration(
          //         hintText: "Search",
          //         focusedBorder: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             color: AppColors.grey.withAlpha(100),
          //             width: 2,
          //           ),
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //         enabledBorder: OutlineInputBorder(
          //           borderSide: BorderSide(color: AppColors.grey.withAlpha(22)),
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 30),
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
          GestureDetector(
            onTap: () {
              context.push(AppRouter.itemResultScreen);
            },
            child: CategoreisListView()
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              "Check Out Our New Recipes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.black.withAlpha(200),
              ),
            ),
          ),
          SizedBox(height: 16),

          NewestItemsListView(),
        ],
      ),
    );
  }
}
