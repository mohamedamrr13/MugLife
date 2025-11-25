import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
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
        color:
            context.isDark
                ? context.cardColor.withOpacity(0.8)
                : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              context.isDark
                  ? context.dividerColor.withOpacity(0.3)
                  : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color:
                context.isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
              style: TextStyle(
                fontFeatures: [FontFeature.tabularFigures()],
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: context.primaryTextColor,
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
          color: context.surfaceColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  context.isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          border:
              context.isDark
                  ? Border.all(
                    color: context.dividerColor.withOpacity(0.2),
                    width: 0.5,
                  )
                  : null,
        ),
        child: Icon(icon, size: 20, color: context.primaryColor),
      ),
    );
  }
}
