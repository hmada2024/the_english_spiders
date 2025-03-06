//lib/core/config/app_routes.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/Learning/compound_words/ui/compound_words_screen.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/ui/similar_words_screen.dart';
import 'package:the_english_spiders/Learning/nouns/ui/nouns_screen.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/ui/verb_conjugations_screen.dart';
import 'package:the_english_spiders/core/screens/games_home_screen.dart';
import 'package:the_english_spiders/core/screens/learning_home_screen.dart';
import 'package:the_english_spiders/core/screens/settings_screen.dart';
import 'package:the_english_spiders/core/screens/about_us_screen.dart';
import 'package:the_english_spiders/core/screens/profile_screen.dart';
import 'package:the_english_spiders/core/screens/quizzes_home_screen.dart';
import 'package:the_english_spiders/Learning/adjectives/ui/adjectives_screen.dart';
import 'package:the_english_spiders/quizzes/collect_compound_words/ui/collect_compound_words_screen.dart';
import 'package:the_english_spiders/quizzes/collect_phrasal_verb/ui/collect_phrasal_verbs_screen.dart';
import 'package:the_english_spiders/quizzes/collect_verb_conjugations/ui/collect_verb_conjugations_screen.dart';
import 'package:the_english_spiders/Games/image_word_matching/ui/image_word_screen.dart';
import 'package:the_english_spiders/quizzes/nouns/ui/choose_image_correct_screen.dart';
import 'package:the_english_spiders/quizzes/nouns/ui/choose_word_correct_screen.dart';
import 'package:the_english_spiders/core/screens/main_screen.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/ui/arrange_sentence_page.dart';
import 'package:the_english_spiders/Learning/phrasal_verbs/ui/phrasal_verbs_screen.dart';
import 'package:the_english_spiders/Learning/modal_semi_modal_verbs/ui/modal_semi_modal_verbs_screen.dart';

class AppRoutes {
  static const String learningHome = '/learning-home';
  static const String nouns = '/learning-home/nouns';
  static const String compoundWords = '/learning-home/compound-words';
  static const String verbConjugationQuiz = '/learning-home/verb-conjugations';
  static const String adjectives = '/learning-home/adjectives';
  static const String phrasalVerbs = '/learning-home/phrasal-verbs';
  static const String modalSemiModalVerbs =
      '/learning-home/modal-semi-modal-verbs';
  static const String settings = '/settings';
  static const String aboutUs = '/about-us';
  static const String profile = '/profile';
  static const String quizzesHome = '/quizzes-home';
  static const String chooseImageCorrectQuiz =
      '/quizzes-home/choose-image-correct';
  static const String chooseWordCorrectQuiz =
      '/quizzes-home/choose-word-correct';
  static const String arrangeSentenceQuiz = '/quizzes-home/arrange-sentence';
  static const String collectCompoundPartQuiz =
      '/quizzes-home/choose-compound-part';
  static const String collectVerbConjugationsQuiz =
      '/quizzes-home/choose-verb-conjugation';
  static const String mainScreen = '/main';
  static const String collectPhrasalVerbsQuiz =
      '/quizzes-home/collect-phrasal-verbs';
  static const String similarWords = '/similar-words';
  static const String imageWordMatchingQuiz =
      '/quizzes-home/image-word-matching';
    static const String gamesHome = '/games-home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      mainScreen: (context) => const MainScreen(),
      learningHome: (context) => const LearningHomeScreen(),
      nouns: (context) => const NounsScreen(),
      compoundWords: (context) => const CompoundWordsScreen(),
      verbConjugationQuiz: (context) => const VerbConjugationsScreen(),
      adjectives: (context) => const AdjectivesScreen(),
      settings: (context) => const SettingsScreen(),
      aboutUs: (context) => const AboutUsScreen(),
      profile: (context) => const ProfileScreen(),
      quizzesHome: (context) => const QuizzesHomeScreen(),
      chooseImageCorrectQuiz: (context) => const ChooseImageCorrectScreen(),
      chooseWordCorrectQuiz: (context) => const ChooseWordCorrectScreen(),
      arrangeSentenceQuiz: (context) => const ArrangeSentenceScreen(),
      collectCompoundPartQuiz: (context) => const CollectCompoundWordsScreen(),
      collectVerbConjugationsQuiz: (context) =>
          const CollectVerbConjugationsScreen(),
      phrasalVerbs: (context) => const PhrasalVerbsScreen(),
      modalSemiModalVerbs: (context) => const ModalSemiModalVerbsScreen(),
      collectPhrasalVerbsQuiz: (context) => const CollectPhrasalVerbsScreen(),
      similarWords: (context) => const SimilarWordsScreen(),
      imageWordMatchingQuiz: (context) => const ImageWordMatchingScreen(),
      gamesHome: (context) => const GamesHomeScreen(), // Add gamesHome route
    };
  }
}