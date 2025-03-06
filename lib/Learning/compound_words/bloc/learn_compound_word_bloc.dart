//lib/Learning_section/blocs/learn_compound_word/learn_compound_word_bloc.dart
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_event.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_state.dart';
import 'package:the_english_spiders/data/repositories/compound_word_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';

class LearnCompoundWordBloc
    extends Bloc<LearnCompoundWordEvent, LearnCompoundWordState> {
  final CompoundWordRepository _compoundWordRepository;
  final AudioService _audioService;

  LearnCompoundWordBloc(this._compoundWordRepository, this._audioService)
      : super(const LearnCompoundWordState()) {
    on<LoadCompoundWords>(_onLoadCompoundWords);
    on<SelectCompoundWord>(_onSelectCompoundWord);
    on<PlayCompoundWordAudio>(_onPlayCompoundWordAudio);
  }

  Future<void> _onLoadCompoundWords(
      LoadCompoundWords event,
      Emitter<LearnCompoundWordState> emit,
      ) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final compoundWords = await _compoundWordRepository.getAll();
      emit(state.copyWith(
        isLoading: false,
        compoundWords: compoundWords,
      ));
    } catch (e) {
      _handleError(emit, e.toString());
    }
  }

  void _onSelectCompoundWord(
      SelectCompoundWord event, Emitter<LearnCompoundWordState> emit) {
    emit(state.copyWith(selectedCompoundWord: event.compoundWord));
  }

  Future<void> _onPlayCompoundWordAudio(
      PlayCompoundWordAudio event,
      Emitter<LearnCompoundWordState> emit,
      ) async {
    Uint8List? audioData;
    try{
      switch (event.audioType) {
        case AudioType.main:
          audioData = event.compoundWord.mainAudio;
          break;
        case AudioType.example:
          audioData = event.compoundWord.mainExampleAudio;
          break;
          default:
          emit(state.copyWith(error: "Invalid audio type for compound word"));
          return;
      }

      if (audioData != null && audioData.isNotEmpty) {
        await _audioService.start(audioData); //  <--  تم التصحيح هنا
        emit(state.copyWith(message: 'Playing audio...'));
      } else {
        emit(state.copyWith(
            message:
            'No audio data available for this compound word.'));
      }
    } catch (e) {
        _handleError(emit, e.toString());
    }
  }

  void _handleError(Emitter<LearnCompoundWordState> emit, String error) {
    emit(state.copyWith(isLoading: false, error: error));
  }
}