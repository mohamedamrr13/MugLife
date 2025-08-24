import 'package:drinks_app/utils/shared/shimmer_widget.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CategoryItemShimmer extends StatelessWidget {
  const CategoryItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurfaceColor : AppTheme.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withOpacity(0.05),
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
              child: ShimmerBox(
                width: 100,
                height: 100,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            const ShimmerText(width: 80, height: 18),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CategoryListShimmer extends StatelessWidget {
  const CategoryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) => const CategoryItemShimmer(),
      ),
    );
  }
}

class NewestItemShimmer extends StatelessWidget {
  const NewestItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Background layers (shimmer effect)
          Positioned(
            bottom: 40,
            left: 45,
            child: ShimmerBox(
              width: 160,
              height: 350,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          Positioned(
            bottom: 55,
            left: 22,
            child: ShimmerBox(
              width: 210,
              height: 350,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          // Main card container
          Container(
            width: 250,
            height: 320,
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurfaceColor : AppTheme.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title shimmer
                  const ShimmerText(width: 150, height: 32),
                  const SizedBox(height: 7),
                  const ShimmerText(width: 120, height: 32),

                  const Spacer(),

                  // Image shimmer
                  Center(child: ShimmerCircle(size: 200)),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewestListShimmer extends StatelessWidget {
  const NewestListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 2,
        itemBuilder: (context, index) => const NewestItemShimmer(),
      ),
    );
  }
}

class ProductListItemShimmer extends StatelessWidget {
  const ProductListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceColor : AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Image shimmer
          ShimmerBox(
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(12),
          ),

          const SizedBox(width: 16),

          // Content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerText(width: double.infinity, height: 18),
                const SizedBox(height: 8),
                const ShimmerText(width: 150, height: 14),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerText(width: 60, height: 16),
                    ShimmerBox(
                      width: 80,
                      height: 32,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListShimmer extends StatelessWidget {
  final int itemCount;

  const ProductListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ProductListItemShimmer(),
    );
  }
}

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurfaceColor : AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Image shimmer
          ShimmerBox(
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(12),
          ),

          const SizedBox(width: 16),

          // Content shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerText(width: double.infinity, height: 16),
                const SizedBox(height: 4),
                const ShimmerText(width: 80, height: 14),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ShimmerText(width: 60, height: 16),
                    const ShimmerText(width: 80, height: 14),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Controls shimmer
          Column(
            children: [
              ShimmerBox(
                width: 28,
                height: 28,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(height: 16),
              ShimmerBox(
                width: 104,
                height: 32,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
