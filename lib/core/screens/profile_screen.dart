//lib/core/screens/profile_screen.dart
import 'package:the_english_spiders/core/user_profile/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/user_profile/user_cubit.dart';
import 'package:the_english_spiders/core/user_profile/profile_page_content.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = AppRoutes.profile;

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: theme.textTheme.displayLarge!.copyWith(color: theme.colorScheme.onPrimary)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(icon: Icon(Icons.settings, color: theme.colorScheme.onPrimary,), onPressed: () {}), //  استخدم ألوان الثيم
          IconButton(icon: Icon(Icons.home, color: theme.colorScheme.onPrimary,), onPressed: () {}), //  استخدم ألوان الثيم
        ],
      ),
      body: Container(
        decoration:
            BoxDecoration(color: theme.colorScheme.surface), //  استخدم ألوان الثيم
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }
            return ProfilePageContent(currentUser: state.user);
          },
        ),
      ),
    );
  }
}