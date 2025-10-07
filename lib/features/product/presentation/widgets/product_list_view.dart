import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({
    super.key,
    required this.products,
    required this.scrollController,
    this.height,
  });

  final List<ProductModel> products;
  final ScrollController scrollController;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final productModel = products[index];

          return AnimatedBuilder(
            animation: scrollController,
            builder: (context, child) {
              double offset = 0;
              if (scrollController.hasClients) {
                // Calculate scroll offset relative to item position
                offset = scrollController.offset / 175 - index;
              }
              // Clamp the offset to prevent negative scaling
              offset = offset.clamp(0.0, 3.0);

              return RepaintBoundary(
                child: Opacity(
                  opacity: (1 - (offset * 0.3)).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: (1 - (offset * 0.2)).clamp(0.0, 1.0),
                    child: child,
                  ),
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                context.push(
                  AppRouter.itemDetailsScreen,
                  extra: {'list': products, 'index': index.toDouble()},
                );
              },
              child: ProductListItem(productModel: productModel),
            ),
          );
        }, childCount: products.length),
      ),
    );
  }
}
