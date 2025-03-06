// lib/quizzes/collect_phrasal_verbs/bloc/collect_phrasal_verbs_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/models/phrasal_verb_model.dart';
import 'package:the_english_spiders/data/repositories/phrasal_verb_repository.dart';

part 'collect_phrasal_verbs_event.dart';
part 'collect_phrasal_verbs_state.dart';

class CollectPhrasalVerbsBloc
    extends Bloc<CollectPhrasalVerbsEvent, ChoosePhrasalVerbPartState> {
  final PhrasalVerbRepository _repository;
  final AudioService _audioService;
  final _random = Random();
  List<PhrasalVerb> _initialData = [];
  final Set<int> _answeredQuestions = {};
  Timer? _interactionTimer;

  CollectPhrasalVerbsBloc(this._repository, this._audioService)
      : super(const ChoosePhrasalVerbPartState(totalQuestions: 0)) {
    on<LoadPhrasalVerbs>(_onLoadPhrasalVerbs);
    on<SelectPhrasalVerbPart>(_onSelectPhrasalVerbPart);
    on<NextPhrasalVerbQuestion>(_onNextPhrasalVerbQuestion);
    on<PlayPhrasalVerbAudio>(_onPlayPhrasalVerbAudio);
    on<StopPhrasalVerbAudio>(_onStopPhrasalVerbAudio);
    on<StartNewPhrasalVerbQuiz>(_onStartNewQuiz);
    on<SkipQuestion>(_onSkipQuestion);
  }

  Future<void> _onStartNewQuiz(
      StartNewPhrasalVerbQuiz event,
      Emitter<ChoosePhrasalVerbPartState> emit) async {
    _resetQuizState();
    add(LoadPhrasalVerbs());
  }

  Future<void> _onLoadPhrasalVerbs(
      LoadPhrasalVerbs event, Emitter<ChoosePhrasalVerbPartState> emit) async {
    if (state.status == CollectPhrasalVerbsStatus.loading) return;

    emit(state.copyWith(
      status: CollectPhrasalVerbsStatus.loading,
      error: null,
      score: 0,
      answeredQuestions: 0,
    ));

    try {
      List<PhrasalVerb> verbs = await _repository.getAll();
      _initialData = List.from(verbs);
      _initialData.shuffle(_random);

      emit(state.copyWith(
        phrasalVerbs: verbs,
        totalQuestions: verbs.length,
        status: CollectPhrasalVerbsStatus.questionReady,
      ));
      if (verbs.isNotEmpty) {
        add(NextPhrasalVerbQuestion());
      } else {
        emit(state.copyWith(
            currentPhrasalVerb: null,
            displayedPart: '',
            answerOptions: [],
            status: CollectPhrasalVerbsStatus.error,
            error: 'No phrasal verbs found.'));
      }
    } catch (e) {
      emit(state.copyWith(
        status: CollectPhrasalVerbsStatus.error,
        error: 'Failed to load phrasal verbs: $e',
      ));
    }
  }

  Future<void> _onSelectPhrasalVerbPart(
    SelectPhrasalVerbPart event, Emitter<ChoosePhrasalVerbPartState> emit) async {
  if (state.status == CollectPhrasalVerbsStatus.correct ||
      state.status == CollectPhrasalVerbsStatus.wrong) {
    return;
  }
  _interactionTimer?.cancel();

  String? part1 = state.selectedPart1;
  String? part2 = event.selectedPart;
  Map<String, PartStatus> newStatus = Map.from(state.selectedPartsStatus); // Copy

  if (part1 == null) {
    // First part selected.
    newStatus[part2] = PartStatus.selected;
    emit(state.copyWith(selectedPart1: part2, selectedPartsStatus: newStatus));
    return;
  }

    bool isCorrect = _checkAnswer(part1, part2);
    newStatus[part1] = isCorrect ? PartStatus.correct : PartStatus.wrong;
    newStatus[part2] = isCorrect ? PartStatus.correct : PartStatus.wrong;

  String soundToPlay = isCorrect
      ? AppConstants.correctAnswerSound
      : AppConstants.wrongAnswerSound;
  try {
    await _audioService.start(await _getAssetData(soundToPlay));
  } catch (e) {
    debugPrint("Error playing sound: $e");
  }
  _answeredQuestions.add(state.currentPhrasalVerb!.id);

   emit(state.copyWith(
    status: isCorrect ? CollectPhrasalVerbsStatus.correct : CollectPhrasalVerbsStatus.wrong,
    score: isCorrect ? state.score + 1 : state.score,
    answeredQuestions: state.answeredQuestions + 1,
    selectedPartsStatus: newStatus, // Update with correct/wrong
    isAnswered: true,
    // Don't reset selectedPart1 here!
  ));

    final completer = Completer<void>();
    _interactionTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!emit.isDone) { // Check if the Bloc is still active.
          add(NextPhrasalVerbQuestion());
        }
        completer.complete();
    });
     await completer.future;
}

bool _checkAnswer(String part1, String part2) {
    PhrasalVerb verb = state.currentPhrasalVerb!;
     return (verb.mainVerb == part1 && verb.particle == part2) ||
           (verb.mainVerb == part2 && verb.particle == part1);
}

  void _onNextPhrasalVerbQuestion(
      NextPhrasalVerbQuestion event,
      Emitter<ChoosePhrasalVerbPartState> emit) {
    _interactionTimer?.cancel();
    PhrasalVerb? nextVerb;

    for (final verb in _initialData) {
      if (!_answeredQuestions.contains(verb.id)) {
        nextVerb = verb;
        break;
      }
    }

    if (nextVerb != null) {
      emit(state.copyWith(
        currentPhrasalVerb: nextVerb,
        displayedPart: "",
        answerOptions: _generateAnswerOptions(nextVerb),
        status: CollectPhrasalVerbsStatus.questionReady,
        selectedPart1: null,
        selectedPartsStatus: {},
        isAnswered: false,
      ));

      if (state.playAudioAutomatically && state.shouldPlayAudio) {
        add(PlayPhrasalVerbAudio(audioBytes: nextVerb.audio));
      }
    } else {
      if (state.answeredQuestions == state.totalQuestions){
          emit(state.copyWith(
            status: CollectPhrasalVerbsStatus.completed,
            currentPhrasalVerb: null,
            displayedPart: '',
            answerOptions: [],
        ));
        }else
        {
          emit(state.copyWith(
          currentPhrasalVerb: null,
          displayedPart: '',
          answerOptions: [],
        ));
        }
    }
  }

  // Generate answer options, including the main verb and particle
List<String> _generateAnswerOptions(PhrasalVerb correctVerb) {
    Set<String> optionsSet = {correctVerb.mainVerb, correctVerb.particle};
    List<PhrasalVerb> otherVerbs = _initialData.where((v) => v.id != correctVerb.id).toList();
    otherVerbs.shuffle(_random);

    int count = 0;
    while (optionsSet.length < 8 && count < otherVerbs.length) {
      optionsSet.add(otherVerbs[count].mainVerb);
      optionsSet.add(otherVerbs[count].particle);
      count++;
    }

    // Ensure we have exactly 8 options, filling with duplicates if necessary
    while (optionsSet.length < 8) {
        int index = _random.nextInt(optionsSet.length);
        optionsSet.add(optionsSet.elementAt(index));
    }

    List<String> options = optionsSet.toList()..shuffle(_random);

    return options;
  }

  Future<void> _onPlayPhrasalVerbAudio(
      PlayPhrasalVerbAudio event, Emitter<ChoosePhrasalVerbPartState> emit) async {
    if (event.audioBytes != null) {
      await _audioService.start(event.audioBytes!);
    }
  }

  Future<void> _onStopPhrasalVerbAudio(
      StopPhrasalVerbAudio event, Emitter<ChoosePhrasalVerbPartState> emit) async {
        await _audioService.stop();
  }

  void _resetQuizState() {
    _initialData.shuffle(_random);
    _answeredQuestions.clear();
  }

  Future<void> _onSkipQuestion(
      SkipQuestion event, Emitter<ChoosePhrasalVerbPartState> emit) async {
    _audioService.stop();
    _interactionTimer?.cancel();

    if (state.currentPhrasalVerb != null) {
      _answeredQuestions.add(state.currentPhrasalVerb!.id);
    }
    add(NextPhrasalVerbQuestion());
  }

  @override
  Future<void> close() {
    _interactionTimer?.cancel();
    return super.close();
  }

  Future<Uint8List> _getAssetData(String assetPath) async {
    final byteData = await GetIt.instance<AssetBundle>().load(assetPath);
    return byteData.buffer.asUint8List();
  }
}