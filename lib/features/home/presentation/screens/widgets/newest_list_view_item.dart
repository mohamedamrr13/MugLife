import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:flutter/material.dart';

class NewestListViewItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String type;
  final String duration;
  final String difficulty;
  final int likes;
  final double rating;
  final String imageAsset;

  const NewestListViewItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.duration,
    required this.difficulty,
    required this.likes,
    required this.rating,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 40,
            left: 45,
            child: Container(
              width: 160,
              height: 350,
              decoration: BoxDecoration(
                color: AppTheme.mainColor.withAlpha(50),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          Positioned(
            bottom: 55,
            left: 22,
            child: Container(
              width: 210,
              height: 350,
              decoration: BoxDecoration(
                color: AppTheme.mainColor.withAlpha(100),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          // Main card container
          Container(
            width: 250,
            height: 320,
            decoration: BoxDecoration(
              color: AppTheme.mainColor,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 0.9,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.7),
                      height: 0.9,
                    ),
                  ),

                  Spacer(),

                  // Cocktail image (centered)
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(imageUrl: imageAsset),
                      ),
                      // Replace with your image:
                      // child: Image.asset(
                      //   imageAsset,
                      //   width: 100,
                      //   height: 100,
                      //   fit: BoxFit.contain,
                      // ),
                    ),
                  ),

                  Spacer(),

                  // Bottom info section
                  // Row(
                  //   children: [
                  //     Icon(
                  //       Icons.local_bar_outlined,
                  //       color: Colors.white,
                  //       size: 18,
                  //     ),
                  //     SizedBox(width: 6),
                  //     Text(
                  //       type,
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // SizedBox(height: 12),

                  // Row(
                  //   children: [
                  //     Icon(Icons.access_time, color: Colors.white, size: 18),
                  //     SizedBox(width: 6),
                  //     Text(
                  //       duration,
                  //       style: TextStyle(color: Colors.white, fontSize: 16),
                  //     ),
                  //     Spacer(),
                  //     Text(
                  //       difficulty,
                  //       style: TextStyle(color: Colors.white, fontSize: 16),
                  //     ),
                  //   ],
                  // ),

                  // SizedBox(height: 12),

                  // Row(
                  //   children: [
                  //     Icon(Icons.favorite, color: Colors.white, size: 18),
                  //     SizedBox(width: 6),
                  //     Text(
                  //       likes.toString(),
                  //       style: TextStyle(color: Colors.white, fontSize: 16),
                  //     ),
                  //     Spacer(),
                  //     // Star rating
                  //     Row(
                  //       children: List.generate(5, (index) {
                  //         return Icon(
                  //           index < rating ? Icons.star : Icons.star_border,
                  //           color: Colors.amber,
                  //           size: 18,
                  //         );
                  //       }),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
