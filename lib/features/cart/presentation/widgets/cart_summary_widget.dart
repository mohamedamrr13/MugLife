import 'package:drinks_app/features/cart/logic/cart_state.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CartSummaryWidget extends StatelessWidget {
  final CartState state;

  const CartSummaryWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Summary Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: (isDark
                        ? AppTheme.darkprimaryColor
                        : AppTheme.primaryColor)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${state.total} items',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark
                          ? AppTheme.darkprimaryColor
                          : AppTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Price Breakdown
        _buildSummaryRow(
          'Subtotal',
          '£${state.subtotal.toStringAsFixed(2)}',
          isDark,
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          'Tax (10%)',
          '£${state.tax.toStringAsFixed(2)}',
          isDark,
        ),
        const SizedBox(height: 8),
        _buildSummaryRow(
          'Delivery Fee',
          state.deliveryFee > 0
              ? '£${state.deliveryFee.toStringAsFixed(2)}'
              : 'Free',
          isDark,
        ),

        const SizedBox(height: 12),

        // Divider
        Divider(
          color: isDark ? AppTheme.darkDividerColor : AppTheme.dividerColor,
          thickness: 1,
        ),

        const SizedBox(height: 12),

        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color:
                    isDark
                        ? AppTheme.darkPrimaryText
                        : AppTheme.lightPrimaryText,
              ),
            ),
            Text(
              '£${state.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppTheme.primaryVariant : AppTheme.primaryColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Savings or Promo Code Section (Optional)
        if (state.deliveryFee == 0)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.successColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  color: AppTheme.successColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Free delivery on orders over £25',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.successColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
