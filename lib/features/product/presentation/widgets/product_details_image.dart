import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/product/data/models/product_model.dart';
import 'package:drinks_app/utils/shared/loading_data_widget.dart';
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
                    return LoadingDataWidget();
                  },
                  imageUrl: product.image,
                  height: screenHeight * 0.42,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 10,
                  child: Opacity(
                    opacity: 0.6,
                    child: Image.asset("assets/drinks/Ellipse 2.png"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
