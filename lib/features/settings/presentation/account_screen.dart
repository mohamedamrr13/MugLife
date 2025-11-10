import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/settings/presentation/widgets/info_card.dart';
import 'package:drinks_app/features/settings/presentation/widgets/stat_card.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // Static data for now - will be replaced with Firebase data
  final Map<String, dynamic> userData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 234 567 8900',
    'address': '123 Main St, New York, NY 10001',
    'memberSince': 'January 2024',
    'totalOrders': 25,
    'totalSpent': 1270,
    'points': 450,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.primaryColor,
                      context.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Profile Picture
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child:
                              currentUser?.photoURL != null
                                  ? CachedNetworkImage(
                                    imageUrl: currentUser!.photoURL!,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Container(
                                          color: Colors.white.withOpacity(0.2),
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Container(
                                          color: Colors.white.withOpacity(0.2),
                                          child: const Icon(
                                            Icons.person,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                  )
                                  : Container(
                                    color: Colors.white.withOpacity(0.2),
                                    child: const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // User Name
                      Text(
                        currentUser?.displayName ?? userData['name'],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // User Email
                      Text(
                        currentUser?.email ?? userData['email'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Member Since
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Member since ${userData['memberSince']}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Cards
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.shopping_bag_outlined,
                          title: 'Orders',
                          value: userData['totalOrders'].toString(),
                          color: context.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.payments_outlined,
                          title: 'Spent',
                          value: '£${userData['totalSpent']}',
                          color: context.successColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          icon: Icons.stars_outlined,
                          title: 'Points',
                          value: userData['points'].toString(),
                          color: context.warningColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Section Title
                  Text(
                    'Account Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Information Cards
                  InfoCard(
                    icon: Icons.person_outline,
                    title: 'Full Name',
                    value: currentUser?.displayName ?? userData['name'],
                    onTap: () {
                      // TODO: Navigate to edit name
                      _showComingSoon(context, 'Edit Name');
                    },
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: currentUser?.email ?? userData['email'],
                    onTap: () {
                      // TODO: Navigate to edit email
                      _showComingSoon(context, 'Edit Email');
                    },
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.phone_outlined,
                    title: 'Phone Number',
                    value: currentUser?.phoneNumber ?? userData['phone'],
                    onTap: () {
                      // TODO: Navigate to edit phone
                      _showComingSoon(context, 'Edit Phone');
                    },
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.location_on_outlined,
                    title: 'Address',
                    value: userData['address'],
                    onTap: () {
                      // TODO: Navigate to edit address
                      _showComingSoon(context, 'Edit Address');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ActionButton(
                    icon: Icons.history,
                    title: 'Order History',
                    subtitle: 'View your past orders',
                    onTap: () {
                      // TODO: Navigate to order history
                      _showComingSoon(context, 'Order History');
                    },
                  ),

                  const SizedBox(height: 12),

                  ActionButton(
                    icon: Icons.favorite_outline,
                    title: 'Favorites',
                    subtitle: 'Your favorite products',
                    onTap: () {
                      // TODO: Navigate to favorites
                      _showComingSoon(context, 'Favorites');
                    },
                  ),

                  const SizedBox(height: 12),

                  ActionButton(
                    icon: Icons.card_giftcard,
                    title: 'Rewards',
                    subtitle: 'View your rewards and offers',
                    onTap: () {
                      // TODO: Navigate to rewards
                      _showComingSoon(context, 'Rewards');
                    },
                  ),

                  const SizedBox(height: 24),

                  // Logout Button
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errMessage),
                            backgroundColor: context.errorColor,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.1),
                              Colors.red.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap:
                                state is LoginLoading
                                    ? null
                                    : () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: const Text('Logout'),
                                            content: const Text(
                                              'Are you sure you want to logout?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      dialogContext,
                                                    ),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(dialogContext);
                                                  context
                                                      .read<LoginCubit>()
                                                      .logout();
                                                  SharedPreferences.getInstance()
                                                      .then((prefs) {
                                                        prefs.remove('userId');
                                                      });
                                                },
                                                child: const Text(
                                                  'Logout',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child:
                                  state is LoginLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.red,
                                        ),
                                      )
                                      : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.logout_rounded,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Logout',
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ],
                                      ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(feature),
          content: Text('$feature will be available in a future update.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor.withOpacity(0.5)),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: context.primaryColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: context.secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
