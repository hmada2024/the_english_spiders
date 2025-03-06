//lib/quizzes/sentence_quizzes/ui/arrange_sentence_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/ui/shared/confirmation_dialog.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/bloc/arrange_sentence_bloc.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/ui/current_sentence_display.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/ui/feedback_message.dart';
import 'package:the_english_spiders/quizzes/sentence_quizzes/ui/sentence_segment_grid.dart';
import 'package:the_english_spiders/quizzes/shared/generic_quiz_page.dart';
import 'package:the_english_spiders/quizzes/shared/question_element.dart';
import 'package:the_english_spiders/quizzes/shared/show_answer_button.dart';
import 'package:the_english_spiders/quizzes/shared/skip_question_button.dart';
import 'dart:typed_data';

class ArrangeSentenceScreen extends StatelessWidget {
  static const routeName = AppRoutes.arrangeSentenceQuiz;

  const ArrangeSentenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArrangeSentenceView();
  }
}

class ArrangeSentenceView extends StatefulWidget {
  const ArrangeSentenceView({super.key});

  @override
  State<ArrangeSentenceView> createState() => _ArrangeSentenceViewState();
}

class _ArrangeSentenceViewState extends State<ArrangeSentenceView> {
  @override
  void initState() {
    super.initState();
    context.read<ArrangeSentenceBloc>().add(ArrangeSentenceLoadData());
  }

  @override
  Widget build(BuildContext context) {
    return GenericQuizPage(
      title: 'Arrange Sentence',
      leading: _buildLeadingButton(context),
      floatingActionButton: _buildShowAnswerButton(),
      content: Column(
        children: [
          Expanded(child: _buildQuizContent()),
          _buildSkipButton(),
        ],
      ),
    );
  }

  Widget _buildLeadingButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppConstants.textColorLight),
      onPressed: () => _handleExit(context),
    );
  }

  Widget _buildShowAnswerButton() {
    return BlocBuilder<ArrangeSentenceBloc, ArrangeSentenceState>(
      builder: (context, state) {
        return ShowAnswerButton(
          onPressed: () => context.read<ArrangeSentenceBloc>().add(ArrangeSentenceShowAnswer()),
          isEnabled: state.status == ArrangeSentenceStatus.questionReady ||
                       state.status == ArrangeSentenceStatus.correct ||
                       state.status == ArrangeSentenceStatus.wrong, // Enabled when question is ready
        );
      },
    );
  }

  Widget _buildQuizContent() {
    return BlocBuilder<ArrangeSentenceBloc, ArrangeSentenceState>(
      builder: (context, state) {
        switch (state.status) {
          case ArrangeSentenceStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ArrangeSentenceStatus.error:
            return Center(child: Text('Error: ${state.error}'));
          case ArrangeSentenceStatus.questionReady:
          case ArrangeSentenceStatus.correct:
          case ArrangeSentenceStatus.wrong:
            return _buildMainContent(state);
          case ArrangeSentenceStatus.completed:
            return const Center(child: Text("Quiz Completed!"));
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildSkipButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenSize.getHeight(context) * 0.02),
      child: BlocBuilder<ArrangeSentenceBloc, ArrangeSentenceState>(
        builder: (context, state) {
          return SkipQuestionButton(
            onPressed: () => context.read<ArrangeSentenceBloc>().add(SkipQuestion()),
            isEnabled: state.status == ArrangeSentenceStatus.questionReady ||
                       state.status == ArrangeSentenceStatus.correct ||
                       state.status == ArrangeSentenceStatus.wrong,
          );
        },
      ),
    );
  }

  Widget _buildMainContent(ArrangeSentenceState state) {
    final screenHeight = ScreenSize.getHeight(context);
    return SingleChildScrollView( //  إضافة SingleChildScrollView هنا
      child: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          _buildScoreRow(state),
          SizedBox(height: screenHeight * 0.03),
          _buildImageQuestion(state, screenHeight),
          SizedBox(height: screenHeight * 0.03),
          const CurrentSentenceDisplay(),
          SizedBox(height: screenHeight * 0.03),
          const SentenceSegmentGrid(),
          SizedBox(height: screenHeight * 0.03),
          const FeedbackMessage(),
          SizedBox(height: screenHeight * 0.03),
        ],
      ),
    );
  }

  Widget _buildScoreRow(ArrangeSentenceState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreItem(
            context,
            'Questions',
            '${state.answeredQuestions}/${state.totalQuestions}',
            AppConstants.greyTextColor,
          ),
          _buildScoreItem(
            context,
            'Correct',
            '${state.score}',
            AppConstants.correctColor,
          ),
        ],
      ),
    );
  }

    Widget _buildImageQuestion(ArrangeSentenceState state, double screenHeight) {
    return Row( // Use a Row to center the image
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        QuestionElement<Uint8List>(
          questionType: QuestionType.image,
          data: state.currentSentence?.image,
          canPlayAudio: state.currentSentence?.audio != null,
          onPlayAudio: () {
            if (state.currentSentence?.audio != null) {
              context.read<ArrangeSentenceBloc>().add(
                    ArrangeSentencePlayAudio(audioBytes: state.currentSentence?.audio),
                  );
            }
          },
           imageHeight: ScreenSize.getWidth(context) * 0.45,
        ),
      ],
    );
  }
  Widget _buildScoreItem(BuildContext context, String label, String value, Color color) {
    final textStyle = TextStyle(
      fontSize: 18,
      fontFamily: AppConstants.defaultFontFamily,
      fontWeight: FontWeight.bold,
      color: color,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyle.copyWith(fontSize: 14, color: AppConstants.greyTextColor)),
          const SizedBox(height: 2),
          Text(value, style: textStyle),
        ],
      ),
    );
  }

  void _handleExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          onConfirm: () {
            context.read<ArrangeSentenceBloc>().add(ArrangeSentenceStopOperations());
            Navigator.of(context).pop(); // Pop dialog
            Navigator.of(context).pop(); // Pop screen
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}