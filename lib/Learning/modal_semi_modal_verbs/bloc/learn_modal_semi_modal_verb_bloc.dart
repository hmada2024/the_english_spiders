import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/models/modal_semi_modal_verb_model.dart';
import 'package:the_english_spiders/data/repositories/modal_semi_modal_verb_repository.dart';

part 'learn_modal_semi_modal_verb_event.dart';
part 'learn_modal_semi_modal_verb_state.dart';

class LearnModalSemiModalVerbBloc
    extends Bloc<LearnModalSemiModalVerbEvent, LearnModalSemiModalVerbState> {
  final ModalSemiModalVerbRepository _repository;
  final AudioService _audioService;

  LearnModalSemiModalVerbBloc(this._repository, this._audioService)
      : super(const LearnModalSemiModalVerbState()) {
    on<LoadModalSemiModalVerbs>(_onLoadModalSemiModalVerbs);
    on<SelectModalSemiModalVerb>(_onSelectModalSemiModalVerb);
    on<PlayModalSemiModalVerbAudio>(_onPlayModalSemiModalVerbAudio);
        on<PlayModalSemiModalVerbExampleAudio>(_onPlayModalSemiModalVerbExampleAudio);

  }

  Future<void> _onLoadModalSemiModalVerbs(
    LoadModalSemiModalVerbs event,
    Emitter<LearnModalSemiModalVerbState> emit,
  ) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final modalSemiModalVerbs =
          await _repository.getAll();
      emit(state.copyWith(
        isLoading: false,
        modalSemiModalVerbs: modalSemiModalVerbs,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
    void _onSelectModalSemiModalVerb(
      SelectModalSemiModalVerb event, Emitter<LearnModalSemiModalVerbState> emit) {
    emit(state.copyWith(selectedModalSemiModalVerb: event.modalSemiModalVerb));
  }

    Future<void> _onPlayModalSemiModalVerbAudio(
    PlayModalSemiModalVerbAudio event,
    Emitter<LearnModalSemiModalVerbState> emit,
  ) async {
    try {
      if (event.modalSemiModalVerb.audio != null) {
        await _audioService.start(event.modalSemiModalVerb.audio!);
      }
    } catch (e) {
      emit(state.copyWith(
          error: 'Failed to play main audio: $e')); // More specific error
    }
  }

  Future<void> _onPlayModalSemiModalVerbExampleAudio(
    PlayModalSemiModalVerbExampleAudio event,
    Emitter<LearnModalSemiModalVerbState> emit,
  ) async {
    try {
      if (event.modalSemiModalVerb.exampleAudio != null) {
        await _audioService.start(event.modalSemiModalVerb.exampleAudio!);
      }
    } catch (e) {
      emit(state.copyWith(
          error:
              'Failed to play example audio: $e')); // More specific error message
    }
  }
}