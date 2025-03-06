// lib/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart
import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/data/database/database_helper.dart';
import 'package:the_english_spiders/data/models/image_segment_model.dart';
import 'package:the_english_spiders/data/models/sentence_model.dart';
import 'package:get_it/get_it.dart';

part 'arrange_sentence_event.dart';
part 'arrange_sentence_state.dart';

class ArrangeSentenceBloc
    extends Bloc<ArrangeSentenceEvent, ArrangeSentenceState> {
  final AudioService _audioService;
  final DatabaseHelper _databaseHelper = GetIt.instance<DatabaseHelper>();
  final _random = Random();
  List<Sentence> _initialData = [];
  final Set<int> _answeredQuestions = {};
  Timer? _interactionTimer;

  ArrangeSentenceBloc(this._audioService)
      : super(ArrangeSentenceState.initial()) {
    on<ArrangeSentenceLoadData>(_onLoadData);
    on<ArrangeSentenceSelectSegment>(_onSelectSegment);
    on<ArrangeSentenceShowAnswer>(_onShowAnswer);
    on<ArrangeSentenceNextQuestion>(_onNextQuestion);
    on<ArrangeSentencePreviousQuestion>(_onPreviousQuestion);
    on<ArrangeSentencePlayAudio>(_onPlayAudio);
    on<ArrangeSentenceStopOperations>(_onStopOperations);
    on<ArrangeSentenceStartNewQuiz>(_onStartNewQuiz);
    on<SkipQuestion>(_onSkipQuestion);
  }

  Future<void> _onLoadData(
    ArrangeSentenceLoadData event,
    Emitter<ArrangeSentenceState> emit,
  ) async {
    if (state.status == ArrangeSentenceStatus.loading) return;
    emit(state.copyWith(status: ArrangeSentenceStatus.loading));

    try {
      List<Sentence> sentences = await _fetchQuizData();
      _initialData = List.from(sentences);
      _initialData.shuffle(_random);

      emit(state.copyWith(
        sentences: sentences,
        totalQuestions: sentences.length,
        status: ArrangeSentenceStatus.questionReady,
      ));

      if (sentences.isNotEmpty) {
        add(ArrangeSentenceNextQuestion());
      } else {
        emit(state.copyWith(
          currentSentence: null,
          shuffledSegments: [],
          status: ArrangeSentenceStatus.error,
          error: "No sentences found.",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ArrangeSentenceStatus.error,
        error: "Failed to load sentences: $e",
      ));
    }
  }

  Future<List<Sentence>> _fetchQuizData() async {
    final db = await _databaseHelper.database;
    List<Sentence> sentenceData = [];

    try {
      final List<Map<String, dynamic>> images = await db.query('images');
      sentenceData = images.map((image) => Sentence.fromMap(image)).toList();

      for (var sentence in sentenceData) {
        final List<Map<String, dynamic>> segments = await db.query(
          'image_segments',
          where: 'image_id = ?',
          whereArgs: [sentence.id],
          orderBy: 'segment_order ASC',
        );
        sentence.segments.addAll(
          segments.map((segment) => ImageSegment.fromMap(segment)).toList(),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Fetching Data: $e");
      }
      rethrow;
    }
    return sentenceData;
  }

  Future<void> _onSelectSegment(
    ArrangeSentenceSelectSegment event,
    Emitter<ArrangeSentenceState> emit,
  ) async {
    if (state.status != ArrangeSentenceStatus.questionReady) return;
    _interactionTimer?.cancel();

    List<String> newUserOrder = [...state.userOrder];
    if (event.isRemove) {
      newUserOrder.remove(event.segment);
    } else {
      newUserOrder.add(event.segment);
    }

    bool isCorrect = _checkAnswer(newUserOrder);
    bool isInteractionDisabled =
        newUserOrder.length == state.currentSentence!.segments.length;
     // <-- تم التعديل هنا
    emit(state.copyWith(
      userOrder: newUserOrder,
      isCorrect: isCorrect,
      isWrong:  isInteractionDisabled && !isCorrect,
      isInteractionDisabled: isInteractionDisabled,
      isAnswered: isInteractionDisabled,
    ));

    if (isInteractionDisabled) {
      await _handleAnswerFeedback(isCorrect, emit);
    }
  }

  bool _checkAnswer(List<String> userOrder) {
    if (state.currentSentence == null) return false;

    List<String> correctOrder =
        state.currentSentence!.segments.map((s) => s.text).toList();
    return listEquals(userOrder, correctOrder);
  }

  Future<void> _handleAnswerFeedback(
    bool isCorrect,
    Emitter<ArrangeSentenceState> emit,
  ) async {
    String soundToPlay = isCorrect
        ? AppConstants.correctAnswerSound
        : AppConstants.wrongAnswerSound;
    try {
      await _audioService.start(await _getAssetData(soundToPlay));
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
    _answeredQuestions.add(state.currentSentence!.id);

    _interactionTimer = Timer(const Duration(milliseconds: 1500), () {
      if (emit.isDone) return;
      add(ArrangeSentenceNextQuestion());
    });
  }

  Future<Uint8List> _getAssetData(String assetPath) async {
    final byteData = await GetIt.instance<AssetBundle>().load(assetPath);
    return byteData.buffer.asUint8List();
  }

  void _onShowAnswer(
    ArrangeSentenceShowAnswer event,
    Emitter<ArrangeSentenceState> emit,
  ) {
    if (state.currentSentence == null) return;

    List<String> correctOrder =
        state.currentSentence!.segments.map((s) => s.text).toList();
    emit(state.copyWith(
      userOrder: correctOrder,
      isInteractionDisabled: true,
    ));

    _interactionTimer?.cancel();
    _interactionTimer = Timer(const Duration(seconds: 3), () {
      if (emit.isDone) return;
      add(ArrangeSentenceNextQuestion());
    });
  }

 void _onNextQuestion(
    ArrangeSentenceNextQuestion event,
    Emitter<ArrangeSentenceState> emit,
  ) {
    _interactionTimer?.cancel();
    Sentence? nextSentence;
    for (final sentence in _initialData) {
      if (!_answeredQuestions.contains(sentence.id)) {
        nextSentence = sentence;
        break;
      }
    }

    if (nextSentence != null) {
      final shuffledSegments = _shuffleSegments(nextSentence.segments);
      emit(state.copyWith(
        currentSentence: nextSentence,
        shuffledSegments: shuffledSegments,
        userOrder: [],
        isCorrect: false,
        isWrong: false,
        isInteractionDisabled: false,
        status: ArrangeSentenceStatus.questionReady,
        answeredQuestions: state.answeredQuestions + 1,
        isAnswered: false,
      ));
      add(ArrangeSentencePlayAudio(audioBytes: nextSentence.audio));
    } else {
        if (state.answeredQuestions == state.totalQuestions) {
            emit(state.copyWith(
                status: ArrangeSentenceStatus.completed,
                currentSentence: null,
                shuffledSegments: [],
                userOrder: [],
                isInteractionDisabled: false,
                answeredQuestions: 0
            ));
        } else {
            emit(state.copyWith(
              currentSentence: null,
              shuffledSegments: [],
              isInteractionDisabled: false,
            ));
        }
    }
  }

    void  _onPreviousQuestion(ArrangeSentencePreviousQuestion event,
      Emitter<ArrangeSentenceState> emit) {}

  List<String> _shuffleSegments(List<ImageSegment> segments) {
    List<String> shuffled = segments.map((s) => s.text).toList();
    shuffled.shuffle(_random);
    return shuffled;
  }

  Future<void> _onPlayAudio(
    ArrangeSentencePlayAudio event,
    Emitter<ArrangeSentenceState> emit,
  ) async {
    if (event.audioBytes != null) {
      await _audioService.start(event.audioBytes!);
    }
  }

  void _onStopOperations(
    ArrangeSentenceStopOperations event,
    Emitter<ArrangeSentenceState> emit,
  ) {
    _interactionTimer?.cancel();
    _audioService.stop();
  }

    Future<void> _onStartNewQuiz(
      ArrangeSentenceStartNewQuiz event, Emitter<ArrangeSentenceState> emit) async {
    _resetQuizState();
    add(ArrangeSentenceLoadData());
  }

    void _resetQuizState() {
        _initialData.shuffle(_random);
        _answeredQuestions.clear();
    }

  // معالج حدث التخطي
  Future<void> _onSkipQuestion(
      SkipQuestion event, Emitter<ArrangeSentenceState> emit) async {
    _audioService.stop();
    _interactionTimer?.cancel();

    if (state.currentSentence != null) {
      _answeredQuestions.add(state.currentSentence!.id);
    }

    add(ArrangeSentenceNextQuestion());
  }

  @override
  Future<void> close() {
    _interactionTimer?.cancel();
    return super.close();
  }
}