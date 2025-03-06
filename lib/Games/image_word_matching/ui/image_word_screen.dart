//lib/Games/image_word_matching/ui/image_word_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/ui/shared/confirmation_dialog.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_bloc.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_event.dart';
import 'package:the_english_spiders/Games/image_word_matching/bloc/image_word_matching_state.dart';
import 'package:the_english_spiders/Games/image_word_matching/ui/card_widget.dart';
import 'package:the_english_spiders/quizzes/shared/generic_quiz_page.dart';

class ImageWordMatchingScreen extends StatelessWidget {
  static const routeName = AppRoutes.imageWordMatchingQuiz;

  const ImageWordMatchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageWordMatchingBloc>.value(
      value: GetIt.instance<ImageWordMatchingBloc>(), // Use GetIt instance
      child: const ImageWordMatchingView(),
    );
  }
}

class ImageWordMatchingView extends StatefulWidget {
  const ImageWordMatchingView({super.key});

  @override
  State<ImageWordMatchingView> createState() => _ImageWordMatchingViewState();
}

class _ImageWordMatchingViewState extends State<ImageWordMatchingView> {
  @override
  void initState() {
    super.initState();
    context.read<ImageWordMatchingBloc>().add(LoadMatchingPairs());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final screenHeight = ScreenSize.getHeight(context);

    final isTablet = ScreenSize.isTablet(context);
    final crossAxisCount = isTablet ? 4 : 3;
    final cardAspectRatio = isTablet ? 1.2 : 0.8;
    final mainAxisSpacing = isTablet ? screenHeight * 0.02 : 8.0;
    final crossAxisSpacing = isTablet ? screenWidth * 0.02 : 8.0;
    final titleFontSize = screenWidth * 0.06;

    final leadingWidget = IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              onConfirm: () {
                context.read<ImageWordMatchingBloc>().add(StopAudioEvent());
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
      title: 'Match Image to Word',
      leading: leadingWidget,
      content: BlocBuilder<ImageWordMatchingBloc, ImageWordMatchingState>(
        builder: (context, state) {
          if (state.status == ImageWordMatchingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ImageWordMatchingStatus.error) {
            return ErrorDisplay(
              errorMessage: state.error!,
              onRetry: () =>
                  context
                      .read<ImageWordMatchingBloc>()
                      .add(LoadMatchingPairs()),
            );
          }

          if (state.status == ImageWordMatchingStatus.completed) {
            return Center(
              child: Text(
                'Congratulations! You matched all pairs!',
                style: TextStyle(fontSize: titleFontSize),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (state.cards.isEmpty) {
            return const Center(
              child: Text("No data available."),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Score: ${state.score}',
                        style: TextStyle(
                            fontSize: titleFontSize,
                            color: AppConstants.primaryColor),
                      ),
                      Text(
                        'Matched: ${state.matchedQuestions}/${state.totalQuestions}',
                        style: TextStyle(
                            fontSize: titleFontSize,
                            color: AppConstants.secondaryColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: cardAspectRatio,
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: crossAxisSpacing,
                    ),
                    itemCount: state.cards.length,
                    itemBuilder: (context, index) {
                      final card = state.cards[index];
                      return CardWidget(
                        card: card,
                        onTap: () {
                          context
                              .read<ImageWordMatchingBloc>()
                              .add(FlipCard(card: card));
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<ImageWordMatchingBloc>().add(ResetGame());
                  },
                  child: const Text('Restart Game'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
