// lib/Learning_section/blocs/learn_verb_conjugation/learn_verb_conjugations_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_event.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_state.dart';
import 'package:the_english_spiders/data/models/verb_conjugations_models.dart';
import 'package:the_english_spiders/data/repositories/verb_conjugations_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';

class LearnVerbConjugationsBloc
    extends Bloc<LearnVerbConjugationsEvent, LearnVerbConjugationsState> {
  final VerbConjugationsRepository _verbRepository;
  final AudioService _audioService;

  LearnVerbConjugationsBloc(this._verbRepository, this._audioService)
      : super(const LearnVerbConjugationsState()) {
    on<LoadVerbs>(_onLoadVerbs);
    on<PlayVerbAudio>(_onPlayVerbAudio);
  }

  Future<void> _onLoadVerbs(
    LoadVerbs event,
    Emitter<LearnVerbConjugationsState> emit,
  ) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final allVerbs = await _verbRepository.getAll();
      List<Verb> filteredVerbs = allVerbs;

      if (event.verbType != null && event.verbType != 'all') {
        filteredVerbs = allVerbs
            .where((verb) =>
                verb.verbType.toLowerCase() == event.verbType!.toLowerCase())
            .toList();
      }

        List<Verb> verbsWithConjugations = [];
        for (final verb in filteredVerbs) {
          List<Conjugations> conjugations = [];
          if(verb.id != null) {
            conjugations = await _verbRepository.getConjugations(verb.id!);
          }
          verbsWithConjugations.add(verb.copyWith(conjugations: conjugations));
        }

      emit(state.copyWith(
        isLoading: false,
        verbs: verbsWithConjugations,
        selectedVerbType: event.verbType,
          conjugations: []
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onPlayVerbAudio(
    PlayVerbAudio event,
    Emitter<LearnVerbConjugationsState> emit,
  ) async {
    try {
      switch (event.audioType) {
        case AudioType.main:
          if (event.verb.baseAudio != null) {
            await _audioService.start(event.verb.baseAudio!);
          }
          break;
        case AudioType.past:
          if (event.verb.conjugations != null && event.verb.conjugations!.isNotEmpty && event.verb.conjugations!.first.pastAudio != null) {
            await _audioService.start(event.verb.conjugations!.first.pastAudio!);
          }
          break;
        case AudioType.pp:
          if (event.verb.conjugations != null && event.verb.conjugations!.isNotEmpty && event.verb.conjugations!.first.ppAudio != null) {
            await _audioService.start(event.verb.conjugations!.first.ppAudio!);
          }
          break;
        default:
          emit(state.copyWith(error: 'Invalid audio type'));
          return;
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to play audio: $e'));
    }
  }
}
