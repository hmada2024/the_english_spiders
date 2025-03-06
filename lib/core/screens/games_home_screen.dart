//lib/core/screens/games_home_screen.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/Games/image_word_matching/ui/image_word_screen.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/screens/profile_screen.dart';
import 'package:the_english_spiders/core/ui/shared/custom_button.dart';
import 'package:the_english_spiders/core/config/button_styles.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class GamesHomeScreen extends StatelessWidget {
  const GamesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Games Section',
          style: theme.textTheme.displayLarge!
              .copyWith(color: theme.colorScheme.onPrimary),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.person,
              color: theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ScreenSize.getWidth(context) *
                (ScreenSize.isTablet(context) ? 0.12 : 0.08)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CustomButton(
                    labelText: 'Match Image to Word',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, ImageWordMatchingScreen.routeName);
                    },
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Game 2', //  Game 2
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Game 3', //  Game 3
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Game 4', //  Game 4
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Game 5', //  Game 5
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
