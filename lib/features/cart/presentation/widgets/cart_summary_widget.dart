import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CartSummaryWidget extends StatelessWidget {
  final Future<double> total;

  const CartSummaryWidget({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
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
            FutureBuilder(
              future: total,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data} L.E.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color:
                        isDark
                            ? AppTheme.primaryVariant
                            : AppTheme.primaryColor,
                  ),
                );
              },
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Savings or Promo Code Section (Optional)
        if (true)
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

  //   Widget _buildSummaryRow(String label, String value, bool isDark) {
  //     return Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: isDark ? AppTheme.darkTextSecondary : AppTheme.textSecondary,
  //           ),
  //         ),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w500,
  //             color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
  //           ),
  //         ),
  //       ],
  //     );
  //   }
}
