import 'package:drinks_app/features/product/presentation/widgets/product_quantity_selector.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ProductDetailsButtonsSection extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductDetailsButtonsSection({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color:
                context.isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.1),
            blurRadius: context.isDark ? 0 : 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionButton(
                  text: "Add To Cart",
                  bgColor: context.primaryColor,
                  textColor: Colors.white,
                  onPressed: onAddToCart,
                ),
                const SizedBox(height: 12),
                ActionButton(
                  text: "Buy Now",
                  bgColor: context.greenBtnColor,
                  textColor: Colors.white,
                  onPressed: onBuyNow,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 115,
            child: ProductQuantitySelector(
              quantity: quantity,
              onQuantityChanged: onQuantityChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
