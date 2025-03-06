//lib/core/widgets/profile/profile_header.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/data/models/user_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel currentUser;
  const ProfileHeader({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final theme = Theme.of(context); // MODIFIED
    final avatarRadius = screenWidth * 0.15;
    final iconSize = screenWidth * 0.2;
//  استخدم حجم الخط من الثيم
    const spacing = AppConstants.marginMedium;

    return Container(
      margin: const EdgeInsets.only(bottom: spacing),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme
                      .shadowColor, // MODIFIED: Use theme.shadowColor (already defined)
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: theme.colorScheme.secondary, // MODIFIED
              child: Icon(
                Icons.person,
                size: iconSize,
                color: theme.colorScheme.onSecondary, // MODIFIED
              ),
            ),
          ),
          const SizedBox(height: spacing),
          Text(
            currentUser.name,
            style: theme.textTheme.displayMedium!.copyWith(
              // MODIFIED
              color: theme.colorScheme.onSurface, // MODIFIED
            ),
          ),
        ],
      ),
    );
  }
}