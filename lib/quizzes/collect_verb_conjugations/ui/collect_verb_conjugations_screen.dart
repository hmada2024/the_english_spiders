// lib/quizzes/collect_verb_conjugations/ui/collect_verb_conjugations_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/quizzes/collect_verb_conjugations/bloc/collect_verb_conjugations_bloc.dart';
import 'package:the_english_spiders/quizzes/shared/generic_answer_option.dart';
import 'package:the_english_spiders/core/ui/shared/confirmation_dialog.dart';
import 'package:the_english_spiders/quizzes/shared/generic_quiz_page.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_content_layout.dart';
import 'package:the_english_spiders/quizzes/shared/question_element.dart';

class CollectVerbConjugationsScreen extends StatelessWidget {
  static const routeName = AppRoutes.collectVerbConjugationsQuiz;

  const CollectVerbConjugationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollectVerbConjugationsView();
  }
}

class CollectVerbConjugationsView extends StatefulWidget {
  const CollectVerbConjugationsView({super.key});

  @override
  State<CollectVerbConjugationsView> createState() =>
      _CollectVerbConjugationsViewState();
}

class _CollectVerbConjugationsViewState
    extends State<CollectVerbConjugationsView> {
  @override
  void initState() {
    super.initState();
    context.read<CollectVerbConjugationsBloc>().add(LoadVerbs());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final screenHeight = ScreenSize.getHeight(context);
    final optionsSpacing = screenWidth * 0.05;
    final correctMessageFontSize = screenWidth * 0.05;
    final baseQuizPadding = screenWidth * 0.03;
    const optionsAspectRatioValue = 1.2;
    final bottomPadding = screenHeight * 0.02;
    final tileWidth = screenWidth * 0.3;
    final tileHeight = screenHeight * 0.1;
    const tileBorderRadius = 12.0;

    final leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final bloc = context.read<CollectVerbConjugationsBloc>();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              onConfirm: () {
                bloc.add(StopVerbAudio());
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
      title: 'Complete the Verb Conjugation',
      leading: leadingWidget,
      content: Column(
        children: [
          Expanded(
            child: BlocBuilder<CollectVerbConjugationsBloc,
                CollectVerbConjugationsState>(
              builder: (context, state) {
                if (state.status == CollectVerbConjugationsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status ==
                    CollectVerbConjugationsStatus.error) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state.status ==
                    CollectVerbConjugationsStatus.completed) {
                  return const Center(child: Text('Quiz Completed!'));
                }

                return QuizContentLayout<String>(
                  title: 'Complete the Verb Conjugation',
                  questionWidget: QuestionElement(
                    questionType: QuestionType.audio,
                    data: state.currentVerb?.baseAudio,
                    canPlayAudio: state.status ==
                        CollectVerbConjugationsStatus.questionReady,
                    onPlayAudio: state.status ==
                            CollectVerbConjugationsStatus.questionReady
                        ? () => context.read<CollectVerbConjugationsBloc>().add(
                            PlayVerbAudio(
                                audioBytes: state.currentVerb?.baseAudio))
                        : null,
                  ),
                  questionWidgetHeight: 150,
                  answerOptions: state.answerOptions.map((conjugation) {
                    ConjugationStatus partStatus =
                        state.selectedConjugationsStatus[conjugation] ??
                            ConjugationStatus.neutral;
                    bool isSelected = partStatus == ConjugationStatus.selected;
                    bool isCorrect = partStatus == ConjugationStatus.correct;
                    bool isWrong = partStatus == ConjugationStatus.wrong;
                    bool isEnabled =
                        state.selectedConjugations.length < 3 && !isSelected;
                    return GenericAnswerOption(
                      data: conjugation.replaceFirst("Duplicate:", ""),
                      isSelected: isSelected,
                      isCorrect: isCorrect,
                      isWrong: isWrong,
                      isEnabled: isEnabled,
                      onTap: () {
                        if (isEnabled) {
                          context.read<CollectVerbConjugationsBloc>().add(
                              SelectConjugation(
                                  selectedConjugation: conjugation));
                        }
                      },
                      width: tileWidth,
                      height: tileHeight,
                      borderRadius: tileBorderRadius,
                      fontSize: screenWidth * 0.04,
                    );
                  }).toList(),
                  score: state.score,
                  answeredQuestions: state.answeredQuestions,
                  totalQuestions: state.totalQuestions,
                  isCorrect:
                      state.status == CollectVerbConjugationsStatus.correct,
                  isWrong: state.status == CollectVerbConjugationsStatus.wrong,
                  onResetQuiz: () {},
                  optionsAspectRatio: optionsAspectRatioValue,
                  optionsCrossAxisCount: 3,
                  optionsType: QuizOptionsType.words,
                  optionsSpacing: optionsSpacing,
                  correctMessageFontSize: correctMessageFontSize,
                  baseQuizPadding: baseQuizPadding,
                  bottomPadding: bottomPadding,
                  showSkipButton: true, 
                  onSkip: () {
                    context
                        .read<CollectVerbConjugationsBloc>()
                        .add(SkipQuestion());
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
