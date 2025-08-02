import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/home/data/models/category_model.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category});
  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffFEF9E4),
          // border: BoxBorder.all(color: AppColors.mainColor, width: 2),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withAlpha(22),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        width: 150,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CachedNetworkImage(imageUrl: category.image, height: 100),
            ),
            SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.black.withAlpha(230),
                fontWeight: FontWeight.w500,
              ),
            ),
            // Text(
            //   "50 mixes",
            //   style: TextStyle(
            //     color: Color(0xffFB7D8A),
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
