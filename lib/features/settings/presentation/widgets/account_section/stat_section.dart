import 'package:drinks_app/features/auth/data/models/user_model.dart';
import 'package:drinks_app/features/settings/presentation/widgets/stat_card.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class StatisticsSection extends StatelessWidget {
  final UserModel? user;

  const StatisticsSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.shopping_bag_outlined,
            title: 'Orders',
            value: user?.ordersCount.toString() ?? '0',
            color: context.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.payments_outlined,
            title: 'Spent',
            value: '\$${user?.totalSpent.toStringAsFixed(2) ?? 0.00}',
            color: context.successColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatCard(
            icon: Icons.stars_outlined,
            title: 'Points',
            value: user?.rewardPoints.toString() ?? '0',
            color: context.warningColor,
          ),
        ),
      ],
    );
  }
}
