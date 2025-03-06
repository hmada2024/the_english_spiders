//lib/core/screens/quizzes_home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/screens/profile_screen.dart';
import 'package:the_english_spiders/core/ui/shared/custom_button.dart';
import 'package:the_english_spiders/quizzes/collect_compound_words/bloc/collect_compound_words_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_compound_words/ui/collect_compound_words_screen.dart';
import 'package:the_english_spiders/quizzes/collect_phrasal_verb/bloc/collect_phrasal_verbs_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_phrasal_verb/ui/collect_phrasal_verbs_screen.dart';
import 'package:the_english_spiders/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_verb_conjugations/ui/collect_verb_conjugations_screen.dart';
import 'package:the_english_spiders/quizzes/nouns/ui/choose_image_correct_screen.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_bloc.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_event.dart'
    as choose_image_events;
import 'package:the_english_spiders/quizzes/nouns/ui/choose_word_correct_screen.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_bloc.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_event.dart'
    as choose_word_events;
import 'package:the_english_spiders/core/config/button_styles.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/ui/arrange_sentence_page.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class QuizzesHomeScreen extends StatelessWidget {
  static const routeName = AppRoutes.quizzesHome;
  const QuizzesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quizzes Section',
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
            padding: EdgeInsets.all(ScreenSize.getWidth(context) * 0.08),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  
                  CustomButton(
                    labelText: 'Choose the Correct Image',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      BlocProvider.of<ChooseCorrectAnswerBloc>(context).add(
                          const choose_image_events.StartNewQuiz(
                              category: 'all'));
                      Navigator.pushNamed(
                          context, ChooseImageCorrectScreen.routeName);
                    },
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Choose the Correct Word',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      BlocProvider.of<ChooseWordCorrectBloc>(context).add(
                          const choose_word_events.StartNewQuiz(
                              category: 'all'));
                      Navigator.pushNamed(
                          context, ChooseWordCorrectScreen.routeName);
                    },
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Arrange Sentence',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      // Use BlocProvider.of to add the StartNewQuiz event.  VERY IMPORTANT.
                      BlocProvider.of<ArrangeSentenceBloc>(context)
                          .add(ArrangeSentenceStartNewQuiz());
                      Navigator.pushNamed(context, ArrangeSentenceScreen.routeName);
                    },
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Complete Compound Word', // New button
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      // Start the new quiz!  VERY IMPORTANT
                      BlocProvider.of<CollectCompoundWordsBloc>(context)
                          .add(StartNewCompoundQuiz());
                      Navigator.pushNamed(
                          context, CollectCompoundWordsScreen.routeName);
                    },
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Verb Conjugation',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      BlocProvider.of<CollectVerbConjugationsBloc>(context)
                          .add(StartNewVerbQuiz());
                      Navigator.pushNamed(
                          context,
                          CollectVerbConjugationsScreen
                              .routeName);
                    },
                  ),
                  const SizedBox(height: AppConstants.marginLarge),
                  CustomButton(
                    labelText: 'Complete Phrasal Verb',
                    style: ButtonStyles.primaryStyle(context),
                    onPressed: () {
                      BlocProvider.of<CollectPhrasalVerbsBloc>(context)
                          .add(StartNewPhrasalVerbQuiz());
                      Navigator.pushNamed(
                          context, CollectPhrasalVerbsScreen.routeName);
                    },
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