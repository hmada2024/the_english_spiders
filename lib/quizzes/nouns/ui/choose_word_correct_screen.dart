//lib/quizzes/nouns/ui/choose_word_correct_screen.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/ui/shared/confirmation_dialog.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_bloc.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_event.dart';
import 'package:the_english_spiders/quizzes/nouns/bloc/choose_word_correct/choose_word_correct_state.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_option_tile.dart';
import 'package:the_english_spiders/quizzes/shared/generic_quiz_page.dart';
import 'package:the_english_spiders/quizzes/shared/question_element.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_content_layout.dart';

class ChooseWordCorrectScreen extends StatelessWidget {
  static const routeName = AppRoutes.chooseWordCorrectQuiz;

  const ChooseWordCorrectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChooseWordCorrectBloc>(
      create: (context) => ChooseWordCorrectBloc(
        GetIt.instance<NounRepository>(),
        GetIt.instance<AudioService>(),
      )..add(const LoadNouns(category: 'all')),
      child: const ChooseWordCorrectView(),
    );
  }
}

class ChooseWordCorrectView extends StatefulWidget {
  const ChooseWordCorrectView({super.key});

  @override
  State<ChooseWordCorrectView> createState() => _ChooseWordCorrectViewState();
}

class _ChooseWordCorrectViewState extends State<ChooseWordCorrectView> {
  final Map<dynamic, ValueNotifier<bool>> _selectionNotifiers = {};

  @override
  void dispose() {
    for (final notifier in _selectionNotifiers.values) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final screenHeight = ScreenSize.getHeight(context);
    final optionsSpacing = screenWidth * 0.05;
    final questionWidgetHeight = screenHeight * 0.25;
    final correctMessageFontSize = screenWidth * 0.05;
    final baseQuizPadding = screenWidth * 0.03;
    const optionsAspectRatioValue = 2.5;
    final bottomPadding = screenHeight * 0.02;

    final leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final bloc = context.read<ChooseWordCorrectBloc>();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              onConfirm: () {
                bloc.add(StopAudio());
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              onCancel: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    );

    return GenericQuizPage(
      title: 'Choose Word Correct',
      leading: leadingWidget,
      content: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChooseWordCorrectBloc, ChooseWordCorrectState>(
              builder: (context, state) {
                if (state.status == ChooseWordCorrectStatus.error) {
                  return ErrorDisplay(
                    errorMessage: state.error!,
                    onRetry: () => context
                        .read<ChooseWordCorrectBloc>()
                        .add(const LoadNouns(category: 'all')),
                  );
                }

                if (state.status == ChooseWordCorrectStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == ChooseWordCorrectStatus.completed) {
                  return const Center(
                    child: Text('Quiz Completed!'),
                  );
                }

                return QuizContentLayout<String>(
                  title: 'Choose Word Correct',
                  questionWidget: QuestionElement<Uint8List>(
                    questionType: QuestionType.image,
                    data: state.currentNoun?.image,
                    imageHeight: questionWidgetHeight,
                    canPlayAudio: true,
                    onPlayAudio: () => context
                        .read<ChooseWordCorrectBloc>()
                        .add(PlayAudio(audioBytes: state.currentNoun?.audio)),
                  ),
                  questionWidgetHeight: questionWidgetHeight,
                  answerOptions: state.answerOptions.map((option) {
                    final notifier = _selectionNotifiers.putIfAbsent(
                        option, () => ValueNotifier<bool>(false));

                    return ValueListenableBuilder<bool>(
                      valueListenable: notifier,
                      builder: (context, isSelected, child) {
                        return QuizOptionTile(
                          data: option,
                          onTap: () {
                            if (state.status ==
                                ChooseWordCorrectStatus.questionReady) {
                              context
                                  .read<ChooseWordCorrectBloc>()
                                  .add(CheckAnswer(selectedAnswer: option));
                            }
                          },
                          isSelected: isSelected,
                          isCorrect:
                              state.status == ChooseWordCorrectStatus.correct &&
                                  option == state.currentNoun?.name,
                          isWrong:
                              state.status == ChooseWordCorrectStatus.wrong &&
                                  option != state.currentNoun?.name,
                          isImageOption: false,
                          selectionNotifier: notifier,
                        );
                      },
                    );
                  }).toList(),
                  score: state.score,
                  answeredQuestions: state.answeredQuestions,
                  totalQuestions: state.totalQuestions,
                  isCorrect: state.status == ChooseWordCorrectStatus.correct,
                  isWrong: state.status == ChooseWordCorrectStatus.wrong,
                  onResetQuiz: () =>
                      context.read<ChooseWordCorrectBloc>().add(ResetQuiz()),
                  optionsAspectRatio: optionsAspectRatioValue,
                  optionsCrossAxisCount: 2,
                  optionsType: QuizOptionsType.words,
                  optionsSpacing: optionsSpacing,
                  correctMessageFontSize: correctMessageFontSize,
                  baseQuizPadding: baseQuizPadding,
                  bottomPadding: bottomPadding,
                  showSkipButton: true,
                  onSkip: () {
                    context.read<ChooseWordCorrectBloc>().add(SkipQuestion());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}