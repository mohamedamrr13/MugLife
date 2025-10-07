import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(24),
        border:
            context.isDark
                ? Border.all(
                  color: context.dividerColor.withOpacity(0.1),
                  width: 0.5,
                )
                : null,
        boxShadow: [
          BoxShadow(
            color:
                context.isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.08),
            blurRadius: context.isDark ? 12 : 8,
            offset: const Offset(0, 4),
            spreadRadius: context.isDark ? 2 : 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 160,
          child: Stack(
            children: [
              // Background gradient overlay for visual depth
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        context.surfaceColor,
                        context.isDark
                            ? context.surfaceColor.withOpacity(0.7)
                            : context.primaryColor.withOpacity(0.02),
                      ],
                    ),
                  ),
                ),
              ),

              // Product Image Section
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 120,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Image shadow
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: context.primaryColor.withOpacity(0.15),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                      ),
                      // Product Image
                      Hero(
                        tag: 'product-${productModel.name}',
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                context.isDark
                                    ? Colors.white.withOpacity(0.05)
                                    : Colors.white.withOpacity(0.8),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: productModel.image,
                              fit: BoxFit.fitHeight,
                              placeholder:
                                  (context, url) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: context.shimmerBaseColor,
                                    ),
                                    child: Icon(
                                      Icons.local_drink,
                                      color: context.secondaryTextColor,
                                      size: 30,
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: context.errorColor.withOpacity(
                                        0.1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.error_outline,
                                      color: context.errorColor,
                                      size: 30,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Section
              Positioned(
                left: 120,
                right: 0,
                top: 0,
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 20, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title and Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productModel.name,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: context.primaryTextColor,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              productModel.description,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.secondaryTextColor,
                                height: 1.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Bottom Row: Price and Arrow
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Price Container
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  context.primaryColor,
                                  context.primaryColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: context.primaryColor.withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              '£${productModel.price}',
                              style: context.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),

                          // Action Button
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color:
                                  context.isDark
                                      ? context.primaryColor.withOpacity(0.15)
                                      : context.primaryColor.withOpacity(0.08),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.primaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: context.primaryColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Subtle highlight overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        context.primaryColor.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
