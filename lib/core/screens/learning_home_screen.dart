//lib/core/screens/learning_home_screen.dart
import 'package:the_english_spiders/Learning/learn_similar_words/ui/similar_words_screen.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/screens/profile_screen.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/Learning/nouns/ui/nouns_screen.dart';
import 'package:the_english_spiders/Learning/compound_words/ui/compound_words_screen.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/ui/verb_conjugations_screen.dart';
import 'package:the_english_spiders/core/ui/shared/custom_button.dart'; // Import CustomButton
import 'package:the_english_spiders/Learning/adjectives/ui/adjectives_screen.dart';
import 'package:the_english_spiders/core/config/button_styles.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/Learning/phrasal_verbs/ui/phrasal_verbs_screen.dart';
import 'package:the_english_spiders/Learning/modal_semi_modal_verbs/ui/modal_semi_modal_verbs_screen.dart';

class LearningHomeScreen extends StatelessWidget {
  static const routeName = AppRoutes.learningHome;
  const LearningHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Section',
            style: theme.textTheme.displayLarge!
                .copyWith(color: theme.colorScheme.onPrimary)),
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
            padding: EdgeInsets.all(ScreenSize.getWidth(context) * 0.08),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CustomButton(
                    labelText: 'Verb Conjugations',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () => Navigator.pushNamed(
                        context, VerbConjugationsScreen.routeName),
                  ),

                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Nouns',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () =>
                        Navigator.pushNamed(context, NounsScreen.routeName),
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Compound Words',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () => Navigator.pushNamed(
                        context, CompoundWordsScreen.routeName),
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Adjectives',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () => Navigator.pushNamed(
                        context, AdjectivesScreen.routeName),
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Phrasal Verbs',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      PhrasalVerbsScreen.routeName,
                    ),
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Modal/Semi-Modal Verbs',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ModalSemiModalVerbsScreen.routeName,
                    ),
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                   CustomButton(
                      labelText: 'Similar Words',
                      style: ButtonStyles.primaryStyle(context),
                      onPressed: () => Navigator.pushNamed(context, SimilarWordsScreen.routeName),
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