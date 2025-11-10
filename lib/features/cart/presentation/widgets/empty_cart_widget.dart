import 'package:drinks_app/utils/shared/app_nav_bar.dart';
import 'package:drinks_app/utils/shared/custom_button.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Cart Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: (isDark
                        ? AppTheme.darkprimaryColor
                        : AppTheme.primaryColor)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 60,
                color:
                    isDark ? AppTheme.darkprimaryColor : AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark ? AppTheme.darkTextPrimary : AppTheme.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Looks like you haven\'t added anything to your cart yet. Start shopping to fill it up!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color:
                    isDark
                        ? AppTheme.darkTextSecondary
                        : AppTheme.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 48),

            // Start Shopping Button
            CustomButton(
              onPressed: () {
                final navbarState =
                    context
                        .findAncestorStateOfType<
                          CustomPageNavigationBarState
                        >();
                navbarState?.navigateToPage(0);
              },
              text: 'Start Shopping',
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
