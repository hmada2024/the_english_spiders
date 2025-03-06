//lib/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/models/verb_conjugations_models.dart';
import 'package:the_english_spiders/data/repositories/verb_conjugations_repository.dart';
import 'package:get_it/get_it.dart';

part 'collect_verb_conjugations_event.dart';
part 'collect_verb_conjugations_state.dart';

class CollectVerbConjugationsBloc
    extends Bloc<CollectVerbConjugationsEvent, CollectVerbConjugationsState> {
  final VerbConjugationsRepository _repository;
  final AudioService _audioService;
  final _random = Random();
  List<Verb> _initialData = [];
  final Set<int> _answeredQuestions = {};
  Timer? _interactionTimer;
  List<Verb> _otherVerbs = [];

  CollectVerbConjugationsBloc(this._repository, this._audioService)
      : super(const CollectVerbConjugationsState(totalQuestions: 0)) {
    on<LoadVerbs>(_onLoadVerbs);
    on<SelectConjugation>(_onSelectConjugation);
    on<NextVerbQuestion>(_onNextVerbQuestion);
    on<PlayVerbAudio>(_onPlayVerbAudio);
    on<StopVerbAudio>(_onStopVerbAudio);
    on<StartNewVerbQuiz>(_onStartNewVerbQuiz);
    on<SkipQuestion>(_onSkipQuestion); // إضافة معالج حدث التخطي
  }

  Future<void> _onStartNewVerbQuiz(
    StartNewVerbQuiz event,
    Emitter<CollectVerbConjugationsState> emit,
  ) async {
    _resetQuizState();
    add(LoadVerbs());
  }

  Future<void> _onLoadVerbs(
      LoadVerbs event, Emitter<CollectVerbConjugationsState> emit) async {
    if (state.status == CollectVerbConjugationsStatus.loading) return;

    try {
      emit(state.copyWith(
        status: CollectVerbConjugationsStatus.loading,
        error: null,
        score: 0,
        answeredQuestions: 0,
      ));

      List<Verb> verbs = await _repository.getAll();

      for (final verb in verbs) {
        List<Conjugations> conjugations =
            await _repository.getConjugations(verb.id!);
        if (conjugations.isNotEmpty) {
          verb.conjugations?.addAll(conjugations);
        }
      }

      _initialData = List.from(verbs);
      _initialData.shuffle(_random);
      _otherVerbs = List.from(_initialData);

      emit(state.copyWith(
        verbs: verbs,
        totalQuestions: verbs.length,
        status: CollectVerbConjugationsStatus.questionReady,
      ));

      if (verbs.isNotEmpty) {
        add(NextVerbQuestion());
      } else {
        emit(state.copyWith(
          currentVerb: null,
          answerOptions: [],
          status: CollectVerbConjugationsStatus.error,
          error: 'No verbs found.',
        ));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error in _onLoadVerbs: $e");
      }
      emit(state.copyWith(
        status: CollectVerbConjugationsStatus.error,
        error: 'Failed to load verbs: $e',
      ));
    }
  }

  Future<void> _onSelectConjugation(
    SelectConjugation event,
    Emitter<CollectVerbConjugationsState> emit,
  ) async {
    if (state.status != CollectVerbConjugationsStatus.questionReady ||
        state.selectedConjugations.contains(event.selectedConjugation) ||
        state.selectedConjugations.length >= 3) {
      return;
    }

    _interactionTimer?.cancel();

    List<String> updatedSelections =
        List.from(state.selectedConjugations); // Use List.from for a copy
    Map<String, ConjugationStatus> updatedStatus =
        Map.from(state.selectedConjugationsStatus); // Copy

    updatedSelections.add(event.selectedConjugation);
    updatedStatus[event.selectedConjugation] = ConjugationStatus.selected;

    emit(state.copyWith(
      selectedConjugations: updatedSelections,
      selectedConjugationsStatus: updatedStatus,
    ));

    if (updatedSelections.length == 3) {
      // Check answer after the third selection
      bool isCorrect = _checkAnswer(updatedSelections);

      //Update UI
      for (final conjugation in updatedSelections) {
        updatedStatus[conjugation] =
            isCorrect ? ConjugationStatus.correct : ConjugationStatus.wrong;
      }

      // Play Sound
      String soundToPlay = isCorrect
          ? AppConstants.correctAnswerSound
          : AppConstants.wrongAnswerSound;
      try {
        await _audioService.start(await _getAssetData(soundToPlay));
      } catch (e) {
        debugPrint("Error playing sound: $e");
      }

      _answeredQuestions.add(state.currentVerb!.id!);

      emit(state.copyWith(
        status: isCorrect
            ? CollectVerbConjugationsStatus.correct
            : CollectVerbConjugationsStatus.wrong,
        score: isCorrect ? state.score + 1 : state.score,
        answeredQuestions: state.answeredQuestions + 1,
        selectedConjugationsStatus: updatedStatus,
        isAnswered: true,
      ));

      final completer = Completer<void>();
      _interactionTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!emit.isDone) {
          add(NextVerbQuestion());
        }
        completer.complete();
      });
      await completer.future;
    }
  }

    bool _checkAnswer(List<String> selected) {
    if (selected.length != 3) {
      return false;
    }

    final verb = state.currentVerb!;
    if (verb.isRegular) {
      // Check for baseForm and pastForm, and the duplicate option.
      return selected.contains(verb.baseForm) &&
          selected.contains(verb.conjugations!.first.pastForm) &&
          selected.where((element) => element.startsWith("Duplicate:")).length == 1;

    } else {
      if (verb.conjugations == null || verb.conjugations!.isEmpty) {
        return false;
      }
      final conjugation = verb.conjugations!.first;
      return selected.contains(verb.baseForm) &&
          selected.contains(conjugation.pastForm) &&
          selected.contains(conjugation.pPForm); //  <--  تعديل هنا
    }
  }

  void _onNextVerbQuestion(
      NextVerbQuestion event, Emitter<CollectVerbConjugationsState> emit) {
    _interactionTimer?.cancel();
    Verb? nextVerb;

    for (final verb in _initialData) {
      if (!_answeredQuestions.contains(verb.id)) {
        nextVerb = verb;
        break;
      }
    }

    if (nextVerb != null) {
      emit(state.copyWith(
        currentVerb: nextVerb,
        answerOptions: _generateAnswerOptions(nextVerb),
        status: CollectVerbConjugationsStatus.questionReady,
        selectedConjugations: [], // Clear previous selections
        selectedConjugationsStatus: {},
        isAnswered: false,
      ));

      if (state.playAudioAutomatically && state.shouldPlayAudio) {
        add(PlayVerbAudio(audioBytes: nextVerb.baseAudio));
      }
    } else {
      if (state.answeredQuestions == state.totalQuestions) {
        emit(state.copyWith(
          status: CollectVerbConjugationsStatus.completed,
          currentVerb: null,
          answerOptions: [],
        ));
      } else {
        emit(state.copyWith(
          currentVerb: null,
          answerOptions: [],
        ));
      }
    }
  }

  List<String> _generateAnswerOptions(Verb correctVerb) {
    Set<String> optionsSet = {};
    optionsSet.add(correctVerb.baseForm);

    if (correctVerb.isRegular) {
      optionsSet.add(correctVerb.conjugations!.first.pastForm!);
      optionsSet.add(
          "Duplicate:${correctVerb.conjugations!.first.pastForm!}"); // Add duplicate
    } else {
      // Irregular verb: add all conjugations
      if (correctVerb.conjugations != null &&
          correctVerb.conjugations!.isNotEmpty) {
        final conjugation = correctVerb.conjugations!.first;
        if (conjugation.pastForm != null) optionsSet.add(conjugation.pastForm!);
        if (conjugation.pPForm != null) optionsSet.add(conjugation.pPForm!);
      }
    }

    // Add random options from other verbs
    List<Verb> otherVerbs =
        _otherVerbs.where((v) => v.id != correctVerb.id).toList();
    otherVerbs.shuffle(_random);

    int count = 0;
    while (optionsSet.length < 9 && count < otherVerbs.length) {
      Verb otherVerb = otherVerbs[count];
      optionsSet.add(otherVerb.baseForm); // Always add base form

      if (otherVerb.conjugations != null &&
          otherVerb.conjugations!.isNotEmpty) {
        final otherConjugation = otherVerb.conjugations!.first;
        if (otherConjugation.pastForm != null) {
          optionsSet.add(otherConjugation.pastForm!);
        }
        if (otherConjugation.pPForm != null) {
          optionsSet.add(otherConjugation.pPForm!);
        }
      }
      count++;
    }

    List<String> options = optionsSet.toList()..shuffle(_random);
    return options;
  }

  Future<void> _onPlayVerbAudio(
      PlayVerbAudio event, Emitter<CollectVerbConjugationsState> emit) async {
    if (event.audioBytes != null) {
      await _audioService.start(event.audioBytes!);
    }
  }

  Future<void> _onStopVerbAudio(
      StopVerbAudio event, Emitter<CollectVerbConjugationsState> emit) async {
    await _audioService.stop();
  }

  void _resetQuizState() {
    _initialData.shuffle(_random);
    _answeredQuestions.clear();
    _otherVerbs = List.from(
        _initialData); // Reset _otherVerbs when starting a new quiz.
  }

    // دالة معالج حدث التخطي
  Future<void> _onSkipQuestion(
            SkipQuestion event, Emitter<CollectVerbConjugationsState> emit) async {
    // أوقف أي صوت قد يكون قيد التشغيل
    _audioService.stop();

    // ألغِ أي مؤقت موجود
    _interactionTimer?.cancel();

    // أضف السؤال الحالي إلى قائمة الأسئلة التي تمت الإجابة عليها (حتى لا يظهر مرة أخرى)
    if (state.currentVerb != null) {
      _answeredQuestions.add(state.currentVerb!.id!);
    }

    // انتقل إلى السؤال التالي (بنفس منطق _onNextQuestion)
    add(NextVerbQuestion());
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