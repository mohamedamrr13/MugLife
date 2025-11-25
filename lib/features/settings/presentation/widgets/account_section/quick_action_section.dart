import 'package:drinks_app/features/settings/presentation/widgets/custom_action_button.dart';
import 'package:drinks_app/features/settings/presentation/widgets/dialog_helpers.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        ActionButton(
          icon: Icons.history,
          title: 'Order History',
          subtitle: 'View your past orders',
          onTap:
              () =>
                  DialogHelpers.showComingSoonDialog(context, 'Order History'),
        ),
        const SizedBox(height: 12),
        ActionButton(
          icon: Icons.favorite_outline,
          title: 'Favorites',
          subtitle: 'Your favorite products',
          onTap: () => DialogHelpers.showComingSoonDialog(context, 'Favorites'),
        ),
        const SizedBox(height: 12),
        ActionButton(
          icon: Icons.card_giftcard,
          title: 'Rewards',
          subtitle: 'View your rewards and offers',
          onTap: () => DialogHelpers.showComingSoonDialog(context, 'Rewards'),
        ),
      ],
    );
  }
}
