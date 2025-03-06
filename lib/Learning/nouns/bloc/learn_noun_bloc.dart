//lib/Learning/nouns/bloc/learn_noun_bloc.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_events.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_state.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';

class LearnNounBloc extends Bloc<LearnNounEvent, LearnNounState> {
  final NounRepository _repository;
  final AudioService _audioService;

  LearnNounBloc(this._repository, this._audioService)
      : super(const LearnNounState()) {
    on<LoadNouns>(_onLoadNouns);
    on<SelectNoun>(_onSelectNoun);
    on<PlayNounAudio>(_onPlayNounAudio);
    on<LoadCategories>(_onLoadCategories);
  }

  Future<void> _onLoadNouns(
    LoadNouns event,
    Emitter<LearnNounState> emit,
  ) async {
    if (state.isLoading) return;
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final nouns = await _repository.getNounsByCategory(event.category);
      final categories = await _repository.getAllCategories();

      if (!event.context.mounted) return;

      for (final noun in nouns) {
        if (noun.image != null) {
          await precacheImage(MemoryImage(noun.image!), event.context);
        }
      }
        if (!event.context.mounted) return; 
      emit(state.copyWith(
        isLoading: false,
        nouns: nouns,
        selectedCategory: event.category,
        categories: categories,
      ));
    } catch (e) {
      _handleError(emit, e.toString());
    }
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<LearnNounState> emit,
  ) async {
    try {
      final categories = await _repository.getAllCategories();
      emit(state.copyWith(categories: categories));
    } catch (e) {
      _handleError(emit, "Failed to load categories: ${e.toString()}");
    }
  }

  void _onSelectNoun(SelectNoun event, Emitter<LearnNounState> emit) {
    emit(state.copyWith(selectedNoun: event.noun));
  }

  Future<void> _onPlayNounAudio(
    PlayNounAudio event,
    Emitter<LearnNounState> emit,
  ) async {
    try {
      if (event.noun.audio != null && event.noun.audio!.isNotEmpty) {
        await _audioService.start(event.noun.audio!);
        emit(state.copyWith(
            message: 'Playing audio for ${event.noun.name}'));
      } else {
        _handleError(emit, 'No audio available for ${event.noun.name}');
      }
    } catch (e) {
      _handleError(emit, 'Failed to play audio for ${event.noun.name}: $e');
    }
  }

  void _handleError(Emitter<LearnNounState> emit, String error) {
    emit(state.copyWith(isLoading: false, error: error));
  }
}