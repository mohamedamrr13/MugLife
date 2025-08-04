import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    required this.controller,
    required this.products,
  });
  final ScrollController controller;
  final List<ProductModel> products;
  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: widget.controller,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final productModel = widget.products[index];
          final listItem = ProductListItem(productModel: productModel);
          return AnimatedBuilder(
            animation: widget.controller,
            builder: (context, child) {
              double offset = 0;
              if (widget.controller.hasClients) {
                offset = widget.controller.offset / 175 - index;
              }
              offset = offset.clamp(0, 3);
              return RepaintBoundary(
                child: Transform.scale(scale: 1 - (offset * 0.2), child: child),
              );
            },
            child: GestureDetector(
              onTap: () {
                context.push(
                  AppRouter.itemDetailsScreen,
                );
              },
              child: listItem,
            ),
          );
        },
      ),
    );
  }
}
