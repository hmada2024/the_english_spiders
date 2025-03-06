import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/models/phrasal_verb_model.dart';
import 'package:the_english_spiders/data/repositories/phrasal_verb_repository.dart';

part 'learn_phrasal_verb_event.dart';
part 'learn_phrasal_verb_state.dart';

class LearnPhrasalVerbBloc
    extends Bloc<LearnPhrasalVerbEvent, LearnPhrasalVerbState> {
  final PhrasalVerbRepository _phrasalVerbRepository;
  final AudioService _audioService;

  LearnPhrasalVerbBloc(this._phrasalVerbRepository, this._audioService)
      : super(const LearnPhrasalVerbState()) {
    on<LoadPhrasalVerbs>(_onLoadPhrasalVerbs);
    on<SelectPhrasalVerb>(_onSelectPhrasalVerb);
    on<PlayPhrasalVerbAudio>(_onPlayPhrasalVerbAudio);
  }

  Future<void> _onLoadPhrasalVerbs(
    LoadPhrasalVerbs event,
    Emitter<LearnPhrasalVerbState> emit,
  ) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final phrasalVerbs =
          await _phrasalVerbRepository.getAll();
      emit(state.copyWith(
        isLoading: false,
        phrasalVerbs: phrasalVerbs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

    void _onSelectPhrasalVerb(
      SelectPhrasalVerb event, Emitter<LearnPhrasalVerbState> emit) {
    emit(state.copyWith(selectedPhrasalVerb: event.phrasalVerb));
  }


  Future<void> _onPlayPhrasalVerbAudio(
    PlayPhrasalVerbAudio event,
    Emitter<LearnPhrasalVerbState> emit,
  ) async {
    try {
      if (event.phrasalVerb.audio != null) {
        await _audioService.start(event.phrasalVerb.audio!);
        emit(state.copyWith(
            message: 'Playing audio for "${event.phrasalVerb.expression}"'));
      } else {
        emit(state.copyWith(
            error: 'No audio available for "${event.phrasalVerb.expression}"'));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Failed to play audio: $e'));
    }
  }
}