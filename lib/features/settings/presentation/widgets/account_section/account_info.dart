// lib/features/settings/presentation/widgets/account_sections/account_info_section.dart
import 'package:drinks_app/features/auth/data/models/user_model.dart';
import 'package:drinks_app/features/settings/presentation/widgets/dialog_helpers.dart';
import 'package:drinks_app/features/settings/presentation/widgets/info_card.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountInfoSection extends StatelessWidget {
  final UserModel? user;
  final User? currentUser;

  const AccountInfoSection({
    super.key,
    required this.user,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.primaryTextColor,
          ),
        ),
        const SizedBox(height: 16),
        InfoCard(
          icon: Icons.person_outline,
          title: 'Full Name',
          value: user?.name ?? currentUser?.displayName ?? 'Not set',
          onTap: () => DialogHelpers.showComingSoonDialog(context, 'Edit Name'),
        ),
        const SizedBox(height: 12),
        InfoCard(
          icon: Icons.email_outlined,
          title: 'Email',
          value: user?.email ?? currentUser?.email ?? 'Not set',
          onTap:
              () => DialogHelpers.showComingSoonDialog(context, 'Edit Email'),
        ),
        const SizedBox(height: 12),
        InfoCard(
          icon: Icons.phone_outlined,
          title: 'Phone Number',
          value: user?.phone ?? currentUser?.phoneNumber ?? 'Not set',
          onTap:
              () => DialogHelpers.showComingSoonDialog(context, 'Edit Phone'),
        ),
        const SizedBox(height: 12),
        InfoCard(
          icon: Icons.location_on_outlined,
          title: 'Saved Addresses',
          value:
              user != null && user!.addressIds.isNotEmpty
                  ? '${user!.addressIds.length} address(es)'
                  : 'No saved addresses',
          onTap:
              () => DialogHelpers.showComingSoonDialog(
                context,
                'Manage Addresses',
              ),
        ),
      ],
    );
  }
}
