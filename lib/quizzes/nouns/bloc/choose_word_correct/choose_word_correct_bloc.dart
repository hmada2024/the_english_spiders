//lib/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_event.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_state.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:get_it/get_it.dart';

class ChooseWordCorrectBloc
    extends Bloc<ChooseWordCorrectEvent, ChooseWordCorrectState> {
  final NounRepository _nounRepository;
  final AudioService _audioService;
   List<Noun> _initialData = [];
  final Set<int> _answeredQuestions = {};
  Timer? _interactionTimer;
  int _consecutiveCorrectAnswers = 0;
  int _consecutiveWrongAnswers = 0;
  final _random = Random();

  ChooseWordCorrectBloc(this._nounRepository, this._audioService)
      : super(const ChooseWordCorrectState(totalQuestions: 0)) {
    on<LoadNouns>(_onLoadNouns);
    on<CheckAnswer>(_onCheckAnswer);
    on<NextQuestion>(_onNextQuestion);
    on<ResetQuiz>(_onResetQuiz);
    on<PlayAudio>(_onPlayAudio);
    on<StopAudio>(_onStopAudio);
    on<StartNewQuiz>(_onStartNewQuiz);
    on<SkipQuestion>(_onSkipQuestion);
  }

  Future<void> _onStartNewQuiz(
      StartNewQuiz event, Emitter<ChooseWordCorrectState> emit) async {
     _resetQuizState();
    add(const LoadNouns(category: 'all'));
  }

    Future<void> _onLoadNouns(LoadNouns event, Emitter<ChooseWordCorrectState> emit) async {
        if (state.status == ChooseWordCorrectStatus.loading) return;

        try {
            emit(state.copyWith(
                status: ChooseWordCorrectStatus.loading,
                error: null,
                score: 0,
                answeredQuestions: 0
            ));

            List<Noun> nouns = await _nounRepository.getAll();
             _initialData = List.from(nouns);
            _initialData.shuffle(_random);

            emit(state.copyWith(
                nouns: nouns,
                totalQuestions: nouns.length,
                status: ChooseWordCorrectStatus.questionReady,
                error: null,
            ));

            if (nouns.isNotEmpty) {
                add(NextQuestion());
            } else {
                emit(state.copyWith(
                    currentNoun: null,
                    answerOptions: [],
                    status: ChooseWordCorrectStatus.error,
                    error: 'No nouns found for this category.',
                ));
            }
        } catch (e) {
            if (kDebugMode) {
                print("Error in _onLoadNouns: $e");
            }
            emit(state.copyWith(
                status: ChooseWordCorrectStatus.error,
                error: 'Failed to load nouns: $e'
            ));
        }
  }
  Future<void> _onCheckAnswer(
      CheckAnswer event, Emitter<ChooseWordCorrectState> emit) async {
    if (state.status == ChooseWordCorrectStatus.correct ||
        state.status == ChooseWordCorrectStatus.wrong) {
      return;
    }
    _interactionTimer?.cancel();

    bool isCorrectAnswer = event.selectedAnswer == state.currentNoun!.name;

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
    try {
      await _audioService.start(await _getAssetData(soundToPlay));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
    _answeredQuestions.add(state.currentNoun!.id);

    emit(state.copyWith(
      status: isCorrectAnswer
          ? ChooseWordCorrectStatus.correct
          : ChooseWordCorrectStatus.wrong,
      score: isCorrectAnswer ? state.score + 1 : state.score,
      answeredQuestions: state.answeredQuestions + 1,
      isInteractionDisabled: true,
      isAnswered: true,
    ));

    final completer = Completer<void>();

    _interactionTimer = Timer(const Duration(milliseconds: 1500), () {
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

   void _onNextQuestion(NextQuestion event, Emitter<ChooseWordCorrectState> emit) {
        Noun? nextNoun;
        for (final noun in _initialData) {
            if (!_answeredQuestions.contains(noun.id)) {
                nextNoun = noun;
                break;
            }
        }

        if (nextNoun != null) {
            final List<String> answerOptions = _generateAnswerOptions(nextNoun);

            emit(state.copyWith(
                currentNoun: nextNoun,
                answerOptions: answerOptions,
                status: ChooseWordCorrectStatus.questionReady,
                isInteractionDisabled: false,
                isAnswered: false,
            ));

            add(PlayAudio(audioBytes: nextNoun.audio));
        } else {
          if (state.answeredQuestions == state.totalQuestions)
          {
             emit(state.copyWith(
                status: ChooseWordCorrectStatus.completed,
                currentNoun: null,
                answerOptions: [],
                isInteractionDisabled: false,
            ));
          }
            else {
              emit(state.copyWith(
                currentNoun: null,
                answerOptions: [],
                isInteractionDisabled: false,
            ));
            }
        }
    }

  List<String> _generateAnswerOptions(Noun correctNoun) {
    final List<String> options = [correctNoun.name];

    final otherNouns =
        _initialData.where((noun) => noun.id != correctNoun.id).toList();
    otherNouns.shuffle();

    for (int i = 0; i < 3 && i < otherNouns.length; i++) {
      options.add(otherNouns[i].name);
    }

    options.shuffle();
    return options;
  }

  Future<void> _onPlayAudio(
      PlayAudio event, Emitter<ChooseWordCorrectState> emit) async {
    if (event.audioBytes != null) {
      await runZonedGuarded(() async {
        await _audioService.start(event.audioBytes!);
      }, (error, stack) {
        debugPrint("Error playing audio: $error");
      });
    }
  }

  Future<void> _onStopAudio(
      StopAudio event, Emitter<ChooseWordCorrectState> emit) async {
    await _audioService.stop();
  }

  void _onResetQuiz(ResetQuiz event, Emitter<ChooseWordCorrectState> emit) {
    _resetQuizState();
    add(const LoadNouns(category: 'all'));
  }

    void _resetQuizState() {
        _initialData.shuffle(_random);
        _answeredQuestions.clear();
        _consecutiveCorrectAnswers = 0;
        _consecutiveWrongAnswers = 0;
    }

  Future<void> _onSkipQuestion(
      SkipQuestion event, Emitter<ChooseWordCorrectState> emit) async {

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