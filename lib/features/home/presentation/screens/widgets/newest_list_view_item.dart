import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:drinks_app/utils/shared/shimmer_widget.dart';
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
            left: MediaQuery.of(context).size.width * 0.05 + 20,
            child: Container(
              width: 170,
              height: 350,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(50),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          Positioned(
            bottom: 55,
            left: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              width: 210,
              height: 350,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withAlpha(100),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          // Main card container
          Container(
            width: 250,
            height: 320,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
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
                        child: CachedNetworkImage(
                          imageUrl: imageAsset,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => ShimmerWidget(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              child: Icon(
                                Icons.local_drink_outlined,
                                size: 70,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Icon(
                              Icons.error_outline_rounded,
                              size: 60,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),

                  Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
