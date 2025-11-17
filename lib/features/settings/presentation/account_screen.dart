import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/auth/data/models/user_model.dart';
import 'package:drinks_app/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:drinks_app/features/auth/presentation/cubit/user_cubit.dart';
import 'package:drinks_app/features/settings/presentation/widgets/info_card.dart';
import 'package:drinks_app/features/settings/presentation/widgets/stat_card.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load user profile when screen initializes
    if (currentUser != null) {
      context.read<UserCubit>().getUserProfile(userId: currentUser!.uid);
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null && currentUser != null) {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Upload the image
        await context.read<UserCubit>().uploadProfilePhoto(
              userId: currentUser!.uid,
              photoFile: File(image.path),
            );

        // Close loading dialog
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload photo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<UserCubit>()
        ..getUserProfile(userId: currentUser?.uid ?? ''),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, userState) {
            UserModel? user;
            bool isLoading = userState is UserLoading;

            if (userState is UserLoaded) {
              user = userState.user;
            }

            return CustomScrollView(
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
                            // Profile Picture with edit button
                            Stack(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border:
                                        Border.all(color: Colors.white, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: user?.photoUrl != null ||
                                            currentUser?.photoURL != null
                                        ? CachedNetworkImage(
                                            imageUrl: user?.photoUrl ??
                                                currentUser!.photoURL!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  child: const Icon(
                                                    Icons.person,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.white
                                                          .withOpacity(0.2),
                                                      child: const Icon(
                                                        Icons.person,
                                                        size: 50,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                          )
                                        : Container(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            child: const Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                // Edit button
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickAndUploadImage,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: context.primaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // User Name
                            Text(
                              user?.name ??
                                  currentUser?.displayName ??
                                  'User',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // User Email
                            Text(
                              user?.email ??
                                  currentUser?.email ??
                                  'email@example.com',
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
                                'Member since ${user != null ? DateFormat('MMMM yyyy').format(user.createdAt) : 'N/A'}',
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
                  child:
                      isLoading
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                          : Padding(
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
                                        value:
                                            user?.ordersCount.toString() ?? '0',
                                        color: context.primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: StatCard(
                                        icon: Icons.payments_outlined,
                                        title: 'Spent',
                                        value:
                                            '\$${user?.totalSpent.toStringAsFixed(2) ?? '0.00'}',
                                        color: context.successColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: StatCard(
                                        icon: Icons.stars_outlined,
                                        title: 'Points',
                                        value:
                                            user?.rewardPoints.toString() ?? '0',
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
                                  value:
                                      user?.name ??
                                          currentUser?.displayName ??
                                          'Not set',
                                  onTap: () {
                                    _showComingSoon(context, 'Edit Name');
                                  },
                                ),

                                const SizedBox(height: 12),

                                InfoCard(
                                  icon: Icons.email_outlined,
                                  title: 'Email',
                                  value:
                                      user?.email ??
                                          currentUser?.email ??
                                          'Not set',
                                  onTap: () {
                                    _showComingSoon(context, 'Edit Email');
                                  },
                                ),

                                const SizedBox(height: 12),

                                InfoCard(
                                  icon: Icons.phone_outlined,
                                  title: 'Phone Number',
                                  value:
                                      user?.phone ??
                                          currentUser?.phoneNumber ??
                                          'Not set',
                                  onTap: () {
                                    _showComingSoon(context, 'Edit Phone');
                                  },
                                ),

                                const SizedBox(height: 12),

                                InfoCard(
                                  icon: Icons.location_on_outlined,
                                  title: 'Saved Addresses',
                                  value:
                                      user != null && user.addressIds.isNotEmpty
                                          ? '${user.addressIds.length} address(es)'
                                          : 'No saved addresses',
                                  onTap: () {
                                    _showComingSoon(context, 'Manage Addresses');
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
                                    _showComingSoon(context, 'Order History');
                                  },
                                ),

                                const SizedBox(height: 12),

                                ActionButton(
                                  icon: Icons.favorite_outline,
                                  title: 'Favorites',
                                  subtitle: 'Your favorite products',
                                  onTap: () {
                                    _showComingSoon(context, 'Favorites');
                                  },
                                ),

                                const SizedBox(height: 12),

                                ActionButton(
                                  icon: Icons.card_giftcard,
                                  title: 'Rewards',
                                  subtitle: 'View your rewards and offers',
                                  onTap: () {
                                    _showComingSoon(context, 'Rewards');
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Logout Button
                                BlocConsumer<LoginCubit, LoginState>(
                                  listener: (context, state) {
                                    if (state is LoginFailure) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                            SnackBar(
                                              content: Text(state.errMessage),
                                              backgroundColor:
                                                  context.errorColor,
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
                                                    _showLogoutDialog(context);
                                                  },
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Center(
                                            child:
                                                state is LoginLoading
                                                    ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.red,
                                                          ),
                                                    )
                                                    : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Icon(
                                                          Icons.logout_rounded,
                                                          color: Colors.red,
                                                        ),
                                                        const SizedBox(width: 8),
                                                        Text(
                                                          'Logout',
                                                          style: theme.textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
            );
          },
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<LoginCubit>().logout();
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('userId');
                });
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
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
