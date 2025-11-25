import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:drinks_app/core/utils/shared/shimmer_widget.dart';
import 'package:flutter/material.dart';

class ProductDetailsImage extends StatelessWidget {
  final ProductModel product;
  final double scale;
  final double translateY;
  final double screenHeight;

  const ProductDetailsImage({
    super.key,
    required this.product,
    required this.scale,
    required this.translateY,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (product.image.isEmpty) {
      return Container(
        height: screenHeight * 0.36,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: 80,
          color: context.secondaryTextColor.withOpacity(0.5),
        ),
      );
    }
    return Transform.translate(
      offset: Offset(translateY, 0),
      child: Transform.scale(
        scale: scale.clamp(0.5, 1.0),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.17),
            Stack(
              children: [
                CachedNetworkImage(
                  placeholder: (context, url) {
                    return SizedBox(
                      height: screenHeight * 0.36,
                      child: Center(
                        child: ShimmerWidget(
                          child: Container(
                            width: screenHeight * 0.36,
                            height: screenHeight * 0.36,
                            decoration: BoxDecoration(
                              color: context.shimmerBaseColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.local_drink_outlined,
                                size: 80,
                                color: context.secondaryTextColor.withOpacity(
                                  0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      height: screenHeight * 0.36,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 60,
                            color: context.errorColor.withOpacity(0.7),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Failed to load image',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  imageUrl: product.image,
                  height: screenHeight * 0.36,
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 300),
                ),
                if (!Theme.of(context).isDark)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        "assets/images/Ellipse 2.png",
                        width: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
