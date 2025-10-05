// Option 1: Remove the controller from ProductListView (Recommended)

import 'package:drinks_app/core/routing/app_router.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/features/product/presentation/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key, required this.products, this.height});
  // Remove controller parameter since it's causing conflicts
  final List<ProductModel> products;
  final double? height;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  // Create a separate controller for this ListView
  late ScrollController _localController;

  @override
  void initState() {
    super.initState();
    _localController = ScrollController();
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller: _localController, // Use local controller
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          final productModel = widget.products[index];
          final listItem = ProductListItem(productModel: productModel);
          return AnimatedBuilder(
            animation: _localController, // Use local controller here too
            builder: (context, child) {
              double offset = 0;
              if (_localController.hasClients) {
                offset = _localController.offset / 175 - index;
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
                  extra: {'list': widget.products, 'index': index.toDouble()},
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
