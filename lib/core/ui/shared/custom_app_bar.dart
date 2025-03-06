//lib/core/widgets/shared/custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.displayLarge!.copyWith(
          color: theme.colorScheme.onPrimary,
          shadows: [
            const Shadow(
              blurRadius: 3.0,
              color: AppConstants.shadowColor,
              offset: Offset(1.0, 1.0),
            ),
          ],
        )
      ),
      leading: leading,
      actions: actions,
      centerTitle: true,
      elevation: AppConstants.defaultElevation,
      backgroundColor: theme.colorScheme.primary,
      iconTheme: IconThemeData(
        color: theme.colorScheme.onPrimary,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
    );
  }
}