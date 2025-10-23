import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/cart/data/models/cart_item_model.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  });

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
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isDark ? AppTheme.darkCardColor : AppTheme.bgScaffoldColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: item.product.image,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color:
                          isDark
                              ? AppTheme.darkCardColor
                              : AppTheme.bgScaffoldColor,
                      child: Icon(
                        Icons.local_drink,
                        color:
                            isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color:
                          isDark
                              ? AppTheme.darkCardColor
                              : AppTheme.bgScaffoldColor,
                      child: Icon(
                        Icons.local_drink,
                        color:
                            isDark
                                ? AppTheme.darkTextSecondary
                                : AppTheme.textSecondary,
                      ),
                    ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isDark
                            ? AppTheme.darkTextPrimary
                            : AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Size: ${item.size}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDark
                            ? AppTheme.darkTextSecondary
                            : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${item.product.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            isDark
                                ? AppTheme.darkprimaryColor
                                : AppTheme.primaryColor,
                      ),
                    ),
                    Text(
                      'Total: £${item.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isDark
                                ? AppTheme.darkTextPrimary
                                : AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Quantity Controls and Remove Button
          Column(
            children: [
              // Remove Button
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppTheme.errorColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Quantity Controls
              Container(
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? AppTheme.darkCardColor
                          : AppTheme.bgScaffoldColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (item.quantity! > 1) {
                          onQuantityChanged(item.quantity! - 1);
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              item.quantity! > 1
                                  ? (isDark
                                      ? AppTheme.darkprimaryColor
                                      : AppTheme.primaryColor)
                                  : (isDark
                                      ? AppTheme.darkTextSecondary
                                      : AppTheme.textSecondary),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isDark
                                  ? AppTheme.darkTextPrimary
                                  : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        onQuantityChanged(item.quantity! + 1);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppTheme.darkprimaryColor
                                  : AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
