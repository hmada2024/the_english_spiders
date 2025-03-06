// lib/quizzes/collect_phrasal_verbs/ui/collect_phrasal_verbs_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/quizzes/collect_phrasal_verb/bloc/collect_phrasal_verbs_bloc.dart';
import 'package:the_english_spiders/quizzes/shared/generic_answer_option.dart';
import 'package:the_english_spiders/core/ui/shared/confirmation_dialog.dart';
import 'package:the_english_spiders/quizzes/shared/generic_quiz_page.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_content_layout.dart';
import 'package:the_english_spiders/quizzes/shared/question_element.dart';

class CollectPhrasalVerbsScreen extends StatelessWidget {
  static const routeName = AppRoutes.collectPhrasalVerbsQuiz;
  const CollectPhrasalVerbsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CollectPhrasalVerbsView();
  }
}

class CollectPhrasalVerbsView extends StatefulWidget {
  const CollectPhrasalVerbsView({super.key});

  @override
  State<CollectPhrasalVerbsView> createState() =>
      _CollectPhrasalVerbsViewState();
}

class _CollectPhrasalVerbsViewState extends State<CollectPhrasalVerbsView> {
  @override
  void initState() {
    super.initState();
    context.read<CollectPhrasalVerbsBloc>().add(LoadPhrasalVerbs());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final screenHeight = ScreenSize.getHeight(context);
    final optionsSpacing = screenWidth * 0.05;
    final correctMessageFontSize = screenWidth * 0.05;
    final baseQuizPadding = screenWidth * 0.03;
    const optionsAspectRatioValue = 2.5;
    final bottomPadding = screenHeight * 0.02;
    final tileWidth = screenWidth * 0.35;
    final tileHeight = screenHeight * 0.12;
    const tileBorderRadius = 12.0;

    final leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        final bloc = context.read<CollectPhrasalVerbsBloc>();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              onConfirm: () {
                bloc.add(StopPhrasalVerbAudio());
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
      title: 'Complete the Phrasal Verb',
      leading: leadingWidget,
      content: Column(
        children: [
          Expanded(
            child:
                BlocBuilder<CollectPhrasalVerbsBloc, ChoosePhrasalVerbPartState>(
              builder: (context, state) {
                if (state.status == CollectPhrasalVerbsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == CollectPhrasalVerbsStatus.error) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state.status ==
                    CollectPhrasalVerbsStatus.completed) {
                  return const Center(child: Text('Quiz Completed!'));
                }

                return QuizContentLayout<String>(
                    title: 'Complete the Phrasal Verb',
                    questionWidget: QuestionElement(
                      questionType: QuestionType.audio,
                      data: state.currentPhrasalVerb?.audio,
                      canPlayAudio: state.status ==
                          CollectPhrasalVerbsStatus.questionReady,
                      onPlayAudio: state.status ==
                              CollectPhrasalVerbsStatus.questionReady
                          ? () => context.read<CollectPhrasalVerbsBloc>().add(
                                PlayPhrasalVerbAudio(
                                    audioBytes: state.currentPhrasalVerb?.audio),
                              )
                          : null,
                    ),
                    questionWidgetHeight: 150,
                    answerOptions: state.answerOptions.map((option) {
                      PartStatus partStatus =
                          state.selectedPartsStatus[option] ??
                              PartStatus.neutral;
                      bool isSelected = partStatus == PartStatus.selected;
                      bool isCorrect = partStatus == PartStatus.correct;
                      bool isWrong = partStatus == PartStatus.wrong;
                      bool isEnabled = state.status ==
                              CollectPhrasalVerbsStatus.questionReady &&
                          !isSelected;

                      return GenericAnswerOption(
                        data: option,
                        isSelected: isSelected,
                        isCorrect: isCorrect,
                        isWrong: isWrong,
                        isEnabled: isEnabled,
                        onTap: () {
                          context
                              .read<CollectPhrasalVerbsBloc>()
                              .add(SelectPhrasalVerbPart(selectedPart: option));
                        },
                        width: tileWidth,
                        height: tileHeight,
                        borderRadius: tileBorderRadius,
                        fontSize: screenWidth * 0.06,
                      );
                    }).toList(),
                    score: state.score,
                    answeredQuestions: state.answeredQuestions,
                    totalQuestions: state.totalQuestions,
                    isCorrect:
                        state.status == CollectPhrasalVerbsStatus.correct,
                    isWrong: state.status == CollectPhrasalVerbsStatus.wrong,
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
                          .read<CollectPhrasalVerbsBloc>()
                          .add(SkipQuestion());
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}