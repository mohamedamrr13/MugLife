import 'package:drinks_app/utils/theming/app_colors.dart';
import 'package:flutter/material.dart';

class ProductQuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const ProductQuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          QuantityButton(
            icon: Icons.remove,
            onPressed: () {
              if (quantity > 1) {
                onQuantityChanged(quantity - 1);
              }
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              quantity.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          QuantityButton(
            icon: Icons.add,
            onPressed: () {
              if (quantity < 40) {
                onQuantityChanged(quantity + 1);
              }
            },
          ),
        ],
      ),
    );
  }
}

// Quantity Button Widget Class
class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const QuantityButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppTheme.mainColor),
      ),
    );
  }
}
