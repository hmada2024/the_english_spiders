//lib/Learning_section/blocs/learn_adjective/learn_adjective_bloc.dart
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_event.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_state.dart';
import 'package:the_english_spiders/data/repositories/adjective_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';

class LearnAdjectiveBloc
    extends Bloc<LearnAdjectiveEvent, LearnAdjectiveState> {
  final AdjectiveRepository _adjectiveRepository;
  final AudioService _audioService;

  LearnAdjectiveBloc(this._adjectiveRepository, this._audioService)
      : super(const LearnAdjectiveState()) {
    on<LoadAllAdjectives>(_onLoadAllAdjectives);
    on<SelectAdjective>(_onSelectAdjective);
    on<PlayAdjectiveAudio>(_onPlayAdjectiveAudio);
  }

  Future<void> _onLoadAllAdjectives(
    LoadAllAdjectives event,
    Emitter<LearnAdjectiveState> emit,
  ) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final adjectives = await _adjectiveRepository.getAll();
      emit(state.copyWith(
        isLoading: false,
        adjectives: adjectives,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  void _onSelectAdjective(
      SelectAdjective event, Emitter<LearnAdjectiveState> emit) {
    emit(state.copyWith(selectedAdjective: event.adjective));
  }

  Future<void> _onPlayAdjectiveAudio(
    PlayAdjectiveAudio event,
    Emitter<LearnAdjectiveState> emit,
  ) async {
    try {
      Uint8List? audioData;
      String audioDescription = '';

      switch (event.audioType) {
        case AudioType.main:
          audioData = event.adjective.mainAdjectiveAudio;
          audioDescription =
              'main adjective "${event.adjective.mainAdjective}"';
          break;
        case AudioType.reverse:
          audioData = event.adjective.reverseAdjectiveAudio;
          audioDescription =
              'reverse adjective "${event.adjective.reverseAdjective}"';
          break;
        case AudioType.example:
          if (event.adjective.mainExampleAudio != null &&
              event.adjective.mainExampleAudio!.isNotEmpty) {
            audioData = event.adjective.mainExampleAudio;
            audioDescription =
                'main example for "${event.adjective.mainAdjective}"';
          } else if (event.adjective.reverseExampleAudio != null &&
              event.adjective.reverseExampleAudio!.isNotEmpty) {
            audioData = event.adjective.reverseExampleAudio;
            audioDescription =
                'reverse example for "${event.adjective.reverseAdjective}"';
          }
          break;
        default:
          emit(state.copyWith(error: 'Invalid audio type requested'));
          return;
      }

      if (audioData != null && audioData.isNotEmpty) {
        await _audioService.start(audioData);
        emit(state.copyWith(message: 'Playing audio for $audioDescription'));
      } else {
        emit(state.copyWith(error: 'No audio available for $audioDescription'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to play audio: $e'));
    }
  }
}