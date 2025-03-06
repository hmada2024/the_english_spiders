//lib/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_event.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_image_correct/choose_image_correct_state.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_options_generator.dart';

class ChooseCorrectAnswerBloc
    extends Bloc<ChooseCorrectAnswerEvent, ChooseCorrectAnswerState> {
  final NounRepository _nounRepository;
  final AudioService _audioService;
  List<Noun> _initialData = [];
  final Set<int> _answeredQuestions = {};
  Timer? _interactionTimer;
  int _consecutiveCorrectAnswers = 0;
  int _consecutiveWrongAnswers = 0;
  final _random = Random();

  ChooseCorrectAnswerBloc(this._nounRepository, this._audioService)
      : super(const ChooseCorrectAnswerState(
            totalQuestions: 0, playAudioAutomatically: true)) {
    on<LoadNouns>(_onLoadNouns);
    on<CheckAnswer>(_onCheckAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<ResetQuiz>(_onResetQuiz);
    on<PlayAudio>(_onPlayAudio);
    on<StopAudio>(_onStopAudio);
    on<LoadSettings>(_onLoadSettings);
    on<SetQuizType>(_onSetQuizType);
    on<StartNewQuiz>(_onStartNewQuiz);
    on<SkipQuestion>(_onSkipQuestion); // معالج الحدث الجديد
  }

  Future<void> _onStartNewQuiz(
      StartNewQuiz event, Emitter<ChooseCorrectAnswerState> emit) async {
    _resetQuizState();
    add(const LoadNouns(category: 'all'));
  }

    Future<void> _onLoadNouns(LoadNouns event, Emitter<ChooseCorrectAnswerState> emit) async {
        if (state.status == ChooseCorrectAnswerStatus.loading) return;

        try {
            emit(state.copyWith(
                status: ChooseCorrectAnswerStatus.loading,
                error: null,
                score: 0,
                answeredQuestions: 0,
            ));

            List<Noun> nouns = await _nounRepository.getAll();
            _initialData = List.from(nouns);
            _initialData.shuffle(_random);

            emit(state.copyWith(
                nouns: nouns,
                totalQuestions: nouns.length,
                status: ChooseCorrectAnswerStatus.questionReady,
                error: null,
            ));

            if (nouns.isNotEmpty) {
                add(NextQuestion());
            } else {
              emit(state.copyWith(
                currentNoun: null,
                answerOptions: [],
                status: ChooseCorrectAnswerStatus.error,
                error: 'No nouns found for this category.',
              ));
            }
        } catch (e) {
          if (kDebugMode) {
            print("Error in _onLoadNouns: $e");
          }
          emit(state.copyWith(
            status: ChooseCorrectAnswerStatus.error,
            error: 'Failed to load nouns: $e',
          ));
        }
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<ChooseCorrectAnswerState> emit,
  ) async {
    bool playAudioAutomatically = true;
    emit(state.copyWith(
        playAudioAutomatically: playAudioAutomatically,
        shouldPlayAudio: playAudioAutomatically));
  }

  Future<void> _onSetQuizType(
      SetQuizType event, Emitter<ChooseCorrectAnswerState> emit) async {
    emit(state.copyWith(quizType: event.quizType));
  }

  Future<void> _onCheckAnswer(
      CheckAnswer event, Emitter<ChooseCorrectAnswerState> emit) async {
    if (state.status == ChooseCorrectAnswerStatus.correct ||
        state.status == ChooseCorrectAnswerStatus.wrong) {
      return;
    }
    _interactionTimer?.cancel();

    bool isCorrectAnswer = false;
    if (state.quizType == QuizType.imageBased) {
      isCorrectAnswer = event.selectedAnswer.id == state.currentNoun!.id;
    } else if (state.quizType == QuizType.textBased) {
      isCorrectAnswer = event.selectedAnswer == state.currentNoun!.name;
    }

    if (isCorrectAnswer) {
      _consecutiveCorrectAnswers++;
      _consecutiveWrongAnswers = 0;
    } else {
      _consecutiveWrongAnswers++;
      _consecutiveCorrectAnswers = 0;
    }

    String soundToPlay = isCorrectAnswer
        ? AppConstants.correctAnswerSound
        : AppConstants.wrongAnswerSound;

    if (_consecutiveCorrectAnswers == 3) {
      soundToPlay = 'assets/sounds/streak_correct.mp3';
      _consecutiveCorrectAnswers = 0;
    } else if (_consecutiveWrongAnswers == 3) {
      soundToPlay = 'assets/sounds/streak_wrong.mp3';
      _consecutiveWrongAnswers = 0;
    }
    await runZonedGuarded(() async {
      await _audioService.start(await _getAssetData(soundToPlay));
    }, (error, stack) {});
    _answeredQuestions.add(state.currentNoun!.id);

    emit(state.copyWith(
      status: isCorrectAnswer
          ? ChooseCorrectAnswerStatus.correct
          : ChooseCorrectAnswerStatus.wrong,
      score: isCorrectAnswer ? state.score + 1 : state.score,
      answeredQuestions: state.answeredQuestions + 1,
      isAnswered: true, // <-- تحديث الحالة هنا
    ));

    final completer = Completer<void>();
    Duration delayDuration = const Duration(milliseconds: 1500);
     if (_consecutiveWrongAnswers == 3) {
       delayDuration = const Duration(seconds: 3);
     }

    _interactionTimer = Timer(delayDuration, () {
      if (emit.isDone) return;
      add(NextQuestion());
      completer.complete();
    });
    await completer.future;
  }

  Future<Uint8List> _getAssetData(String assetPath) async {
    final byteData = await GetIt.instance<AssetBundle>().load(assetPath);
    return byteData.buffer.asUint8List();
  }

  void _onNextQuestion(
    NextQuestion event, Emitter<ChooseCorrectAnswerState> emit) {
    Noun? nextNoun;
    for (final noun in _initialData) {
        if (!_answeredQuestions.contains(noun.id)) {
            nextNoun = noun;
            break;
        }
    }

    if (nextNoun != null) {
        final answerOptions = QuizOptionsGenerator.generateOptions(
            correctAnswer: nextNoun,
            allItems: _initialData,
            quizType: state.quizType,
            valueGetter: (noun) => state.quizType == QuizType.imageBased ? noun : noun.name,
        );

        emit(state.copyWith(
            currentNoun: nextNoun,
            answerOptions: answerOptions,
            status: ChooseCorrectAnswerStatus.questionReady,
            isAnswered: false, // <-- إعادة تعيين الحالة
        ));

        if (state.playAudioAutomatically && state.shouldPlayAudio) {
            add(PlayAudio(audioBytes: nextNoun.audio));
        }

    } else {
        if (state.answeredQuestions == state.totalQuestions)
        {
              emit(state.copyWith(
                status: ChooseCorrectAnswerStatus.completed,
                currentNoun: null,
                answerOptions: [],
              ));
        } else {
          emit(state.copyWith(
            currentNoun: null,
            answerOptions: [],
          ));
        }
    }
}

  Future<void> _onPlayAudio(
      PlayAudio event, Emitter<ChooseCorrectAnswerState> emit) async {
    if (event.audioBytes != null) {
      await runZonedGuarded(() async {
        await _audioService.start(event.audioBytes!);
      }, (error, stack) {
        debugPrint("_onPlayAudio: Error: $error");
      });
    }
  }

  Future<void> _onStopAudio(
      StopAudio event, Emitter<ChooseCorrectAnswerState> emit) async {
    await _audioService.stop();
  }

    void _onResetQuiz(ResetQuiz event, Emitter<ChooseCorrectAnswerState> emit) {
        _resetQuizState();
        add(const LoadNouns(category: 'all'));
    }

    void _resetQuizState() {
        _initialData.shuffle(_random);
        _answeredQuestions.clear();
        _consecutiveCorrectAnswers = 0;
        _consecutiveWrongAnswers = 0;
    }

 // معالج حدث SkipQuestion
  Future<void> _onSkipQuestion(
      SkipQuestion event, Emitter<ChooseCorrectAnswerState> emit) async {
    _audioService.stop();

    _interactionTimer?.cancel();

    if (state.currentNoun != null) {
      _answeredQuestions.add(state.currentNoun!.id);
    }

    add(NextQuestion());
  }

  @override
  Future<void> close() {
    _interactionTimer?.cancel();
    return super.close();
  }
}