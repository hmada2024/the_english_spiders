//lib/core/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/settings/settings_body.dart';
import 'package:the_english_spiders/core/screens/profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = AppRoutes.settings;

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.displayLarge!.copyWith(color: theme.colorScheme.onPrimary),),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(Icons.person, color: theme.colorScheme.onPrimary),
              onPressed: () =>
                  Navigator.pushNamed(context, ProfileScreen.routeName)),
        ],
      ),
      body: const SettingsBody(),
    );
  }
}