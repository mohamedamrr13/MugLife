import 'package:drinks_app/features/drinks/presentation/widgets/drink_quantity_section.dart';
import 'package:flutter/material.dart';

class ActionButtonsSection extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ActionButtonsSection({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
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
                  bgColor: const Color(0xFF6C5CE7),
                  textColor: Colors.white,
                  onPressed: onAddToCart,
                ),
                const SizedBox(height: 12),
                ActionButton(
                  text: "Buy Now",
                  bgColor: const Color(0xFF00B894),
                  textColor: Colors.white,
                  onPressed: onBuyNow,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 115,
            child: QuantitySelector(
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
