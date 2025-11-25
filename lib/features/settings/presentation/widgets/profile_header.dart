// lib/features/settings/presentation/widgets/profile_header.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileHeader extends StatelessWidget {
  final String? photoUrl;
  final String name;
  final String email;
  final DateTime? memberSince;
  final VoidCallback? onEditPhoto;
  final bool showEditButton;

  const ProfileHeader({
    super.key,
    this.photoUrl,
    required this.name,
    required this.email,
    this.memberSince,
    this.onEditPhoto,
    this.showEditButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Stack(
          children: [
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
                    photoUrl != null
                        ? CachedNetworkImage(
                          imageUrl: photoUrl!,
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
            if (showEditButton && onEditPhoto != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditPhoto,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
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
        Text(
          name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        if (memberSince != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Member since ${DateFormat('MMMM yyyy').format(memberSince!)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
