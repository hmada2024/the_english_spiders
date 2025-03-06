//lib/core/widgets/profile/profile_options.dart
import 'package:the_english_spiders/core/screens/settings_screen.dart';
import 'package:the_english_spiders/core/user_profile/option_tile.dart';
import 'package:the_english_spiders/core/user_profile/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

class ProfileOptions extends StatelessWidget {
  final VoidCallback onEditProfileTap;
  const ProfileOptions({super.key, required this.onEditProfileTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: AppConstants.defaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: <Widget>[
          OptionTile(
            leading: Icon(Icons.edit, color: theme.colorScheme.primary),
            title: 'Edit Profile',
            trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
            onTap: onEditProfileTap,
          ),
          const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey),
          OptionTile(
            leading: Icon(Icons.settings, color: theme.colorScheme.primary),
            title: 'App Settings',
            trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
            onTap: () => Navigator.pushNamed(context, SettingsScreen.routeName),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          OptionTile(
            leading: Icon(Icons.logout, color: theme.colorScheme.primary),
            title: 'Logout',
            trailing: Icon(Icons.arrow_forward_ios, color: theme.colorScheme.primary),
            onTap: () async {
              final prefs = GetIt.instance<SharedPreferences>();
              await prefs.remove('username');

              // Use a Builder to get a new context *after* the await.
              Builder(
                builder: (newContext) {
                  return FutureBuilder(
                    future: Future.value(true), // Trivial future
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        BlocProvider.of<UserCubit>(newContext).updateUser(UserModel(name: '', gender: ''));
                        Navigator.pushReplacementNamed(newContext, AppRoutes.learningHome);
                      }
                      return const SizedBox.shrink();
                    },

                  );
                }
              );
            },
          ),
        ],
      ),
    );
  }
}