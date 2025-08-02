import 'package:drinks_app/features/home/data/models/drink_model.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final DrinkModel drink;
  final double scale;
  final double translateY;
  final double screenHeight;

  const ProductItem({
    super.key,
    required this.drink,
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
                Image.asset(drink.image, height: screenHeight * 0.42),
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
