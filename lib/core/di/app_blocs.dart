import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/di/app_dependencies.dart'; // استيراد الـ getIt
import 'package:the_english_spiders/core/user_profile/user_cubit.dart';
import 'package:the_english_spiders/core/theme/theme_cubit.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_bloc.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_bloc.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_compound_words/bloc/collect_compound_words_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_phrasal_verb/bloc/collect_phrasal_verbs_bloc.dart';

List<BlocProvider> createBlocProviders() {
  return [
    BlocProvider<UserCubit>(create: (context) => getIt<UserCubit>()),
    BlocProvider<ThemeCubit>(create: (context) => getIt<ThemeCubit>()),
    BlocProvider<ChooseCorrectAnswerBloc>(
        create: (context) => getIt<ChooseCorrectAnswerBloc>()),
    BlocProvider<ChooseWordCorrectBloc>(
        create: (context) => getIt<ChooseWordCorrectBloc>()),
    BlocProvider<ArrangeSentenceBloc>(
        create: (context) => getIt<ArrangeSentenceBloc>()),
    BlocProvider<CollectCompoundWordsBloc>(
        create: (context) => getIt<CollectCompoundWordsBloc>()),
    BlocProvider<CollectVerbConjugationsBloc>(
        create: (context) => getIt<CollectVerbConjugationsBloc>()),
    BlocProvider<CollectPhrasalVerbsBloc>(
      create: (context) => getIt<CollectPhrasalVerbsBloc>(),
    ),
  ];
}