// lib/Learning_section/blocs/learn_similar_words/learn_similar_words_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_event.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_state.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/repositories/similar_words_repository.dart';

class LearnSimilarWordsBloc
    extends Bloc<LearnSimilarWordsEvent, LearnSimilarWordsState> {
  final SimilarWordsRepository _repository;
  final AudioService _audioService;

  LearnSimilarWordsBloc(this._repository, this._audioService)
      : super(const LearnSimilarWordsState()) {
    on<LoadSimilarWords>(_onLoadSimilarWords);
    on<PlaySeedWordAudio>(_onPlaySeedWordAudio);
    on<PlayBranchWordAudio>(_onPlayBranchWordAudio);
  }

  Future<void> _onLoadSimilarWords(
    LoadSimilarWords event,
    Emitter<LearnSimilarWordsState> emit,
  ) async {
      // ... (Loading, error handling, fetching data from repository)
      final seedsWithBranches = await _repository.getAllSeedsWithBranches();
      emit(state.copyWith(
          isLoading: false, seedsWithBranches: seedsWithBranches));
  }

    Future<void> _onPlaySeedWordAudio(
      PlaySeedWordAudio event,
      Emitter<LearnSimilarWordsState> emit,
    ) async {
      if (event.seedWord.audio != null) {
        await _audioService.start(event.seedWord.audio!);
      }
    }

    Future<void> _onPlayBranchWordAudio(
      PlayBranchWordAudio event,
      Emitter<LearnSimilarWordsState> emit,
    ) async {
      if (event.branchWord.audio != null) {
        await _audioService.start(event.branchWord.audio!);
      }
    }

}