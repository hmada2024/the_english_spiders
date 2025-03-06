//lib/core/di/app_module.dart
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_bloc.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/repositories/adjective_repository.dart';
import 'package:the_english_spiders/data/repositories/compound_word_repository.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/data/repositories/similar_words_repository.dart';
import 'package:the_english_spiders/data/repositories/verb_conjugations_repository.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_bloc.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_bloc.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_bloc.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/core/user_profile/user_cubit.dart';
import 'package:the_english_spiders/core/theme/theme_cubit.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_compound_words/bloc/collect_compound_words_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_phrasal_verb/bloc/collect_phrasal_verbs_bloc.dart';
import 'package:the_english_spiders/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_bloc.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_bloc.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_bloc.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_bloc.dart';
import 'package:flutter/services.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';
import 'package:the_english_spiders/data/repositories/user_repository.dart';
import 'package:the_english_spiders/data/repositories/phrasal_verb_repository.dart';
import 'package:the_english_spiders/Learning/phrasal_verbs/bloc/learn_phrasal_verb_bloc.dart';
import 'package:the_english_spiders/data/repositories/modal_semi_modal_verb_repository.dart';
import 'package:the_english_spiders/Learning/modal_semi_modal_verbs/bloc/learn_modal_semi_modal_verb_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Initialize and register DatabaseHelper
  final dbHelper = await DatabaseHelper.initialize();
  getIt.registerSingleton<DatabaseHelper>(dbHelper);

  // SharedPreferences (Synchronous Registration - Best Practice)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Register AudioService as a Singleton
  getIt.registerLazySingleton<AudioService>(() => AudioService());

  // AssetBundle (use rootBundle)
  getIt.registerLazySingleton<AssetBundle>(() => rootBundle);

  // Register Cubits
  getIt.registerFactory<UserCubit>(() => UserCubit(getIt<UserRepository>()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(getIt<DatabaseHelper>()));

  // Register Repositories (using the DatabaseHelper instance)
  getIt.registerLazySingleton<AdjectiveRepository>(
      () => AdjectiveRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<CompoundWordRepository>(
      () => CompoundWordRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<NounRepository>(
      () => NounRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<VerbConjugationsRepository>(
      () => VerbConjugationsRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<PhrasalVerbRepository>(
      () => PhrasalVerbRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<ModalSemiModalVerbRepository>(
      () => ModalSemiModalVerbRepository(getIt<DatabaseHelper>()));
  getIt.registerLazySingleton<SimilarWordsRepository>(
      () => SimilarWordsRepository(getIt<DatabaseHelper>()));

  // Register Blocs (using the Repositories)
  getIt.registerFactory<LearnAdjectiveBloc>(() =>
      LearnAdjectiveBloc(getIt<AdjectiveRepository>(), getIt<AudioService>()));
  getIt.registerFactory<LearnCompoundWordBloc>(() => LearnCompoundWordBloc(
      getIt<CompoundWordRepository>(), getIt<AudioService>()));
  getIt.registerFactory<LearnNounBloc>(
      () => LearnNounBloc(getIt<NounRepository>(), getIt<AudioService>()));
  getIt.registerFactory<LearnVerbConjugationsBloc>(() =>
      LearnVerbConjugationsBloc(
          getIt<VerbConjugationsRepository>(), getIt<AudioService>()));
  getIt.registerLazySingleton<ChooseCorrectAnswerBloc>(
    () =>
        ChooseCorrectAnswerBloc(getIt<NounRepository>(), getIt<AudioService>()),
  );
  getIt.registerFactory<ChooseWordCorrectBloc>(
    () => ChooseWordCorrectBloc(getIt<NounRepository>(), getIt<AudioService>()),
  );
  getIt.registerFactory<ArrangeSentenceBloc>(
    () => ArrangeSentenceBloc(getIt<AudioService>()),
  );
  getIt.registerFactory<CollectCompoundWordsBloc>(
    () => CollectCompoundWordsBloc(
        getIt<CompoundWordRepository>(), getIt<AudioService>()),
  );
  getIt.registerFactory<CollectVerbConjugationsBloc>(() =>
      CollectVerbConjugationsBloc(
          getIt<VerbConjugationsRepository>(), getIt<AudioService>()));
  getIt.registerFactory<LearnPhrasalVerbBloc>(() => LearnPhrasalVerbBloc(
      getIt<PhrasalVerbRepository>(), getIt<AudioService>()));

  getIt.registerFactory<LearnModalSemiModalVerbBloc>(() =>
      LearnModalSemiModalVerbBloc(
          getIt<ModalSemiModalVerbRepository>(), getIt<AudioService>()));

  getIt.registerFactory<CollectPhrasalVerbsBloc>(
    () => CollectPhrasalVerbsBloc(
        getIt<PhrasalVerbRepository>(), getIt<AudioService>()),
  );

  getIt.registerFactory<LearnSimilarWordsBloc>(() => LearnSimilarWordsBloc(
      getIt<SimilarWordsRepository>(), getIt<AudioService>()));

  getIt.registerFactory<ImageWordMatchingBloc>(() => ImageWordMatchingBloc(
      getIt<NounRepository>(), getIt<AudioService>(), getIt<AssetBundle>()));
}
