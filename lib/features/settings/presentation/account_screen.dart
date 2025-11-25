import 'dart:io';
import 'package:drinks_app/core/di/service_locator.dart';
import 'package:drinks_app/features/auth/data/models/user_model.dart';
import 'package:drinks_app/features/auth/presentation/cubit/user_cubit.dart';
import 'package:drinks_app/features/settings/presentation/widgets/account_section/account_info.dart';
import 'package:drinks_app/features/settings/presentation/widgets/account_section/logout_button.dart';
import 'package:drinks_app/features/settings/presentation/widgets/account_section/quick_action_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/account_section/stat_section.dart';
import 'package:drinks_app/features/settings/presentation/widgets/gradient_appbar.dart';
import 'package:drinks_app/features/settings/presentation/widgets/profile_header.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      context.read<UserCubit>().getUserProfile(userId: currentUser!.uid);
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null && currentUser != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => const Center(child: CircularProgressIndicator()),
        );

        await context.read<UserCubit>().uploadProfilePhoto(
          userId: currentUser!.uid,
          photoFile: File(image.path),
        );

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
    return BlocProvider(
      create:
          (context) =>
              getIt<UserCubit>()
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
                GradientAppBar(
                  title: 'Account',
                  expandedHeight: 280,
                  flexibleSpaceContent: FlexibleSpaceBar(
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
                        child: ProfileHeader(
                          photoUrl: user?.photoUrl ?? currentUser?.photoURL,
                          name:
                              user?.name ?? currentUser?.displayName ?? 'User',
                          email:
                              user?.email ??
                              currentUser?.email ??
                              'email@example.com',
                          memberSince: user?.createdAt,
                          showEditButton: true,
                          onEditPhoto: pickAndUploadImage,
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      isLoading
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                          : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatisticsSection(user: user),
                                const SizedBox(height: 24),
                                AccountInfoSection(
                                  user: user,
                                  currentUser: currentUser,
                                ),
                                const SizedBox(height: 24),
                                const QuickActionsSection(),
                                const SizedBox(height: 24),
                                const LogoutButton(),
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
}
