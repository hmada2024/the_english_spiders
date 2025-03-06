//lib/quizzes_section/shared_quizzes/widgets/quiz_option_tile.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/data/models/nouns_model.dart';
import 'package:the_english_spiders/quizzes/shared/quiz_widget_helpers.dart';

class QuizOptionTile extends StatefulWidget {
  final dynamic data;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final bool isImageOption;
  final ValueNotifier<bool> selectionNotifier;

  const QuizOptionTile({
    super.key,
    required this.data,
    this.onTap,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    this.isImageOption = false,
    required this.selectionNotifier,
  });

  @override
  QuizOptionTileState createState() => QuizOptionTileState();
}

class QuizOptionTileState extends State<QuizOptionTile> {
  @override
  void initState() {
    super.initState();
    widget.selectionNotifier.value = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant QuizOptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      widget.selectionNotifier.value = widget.isSelected;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Add this line
    final boxDecoration = getBoxDecorationForAnswer(
      widget.isSelected && widget.isCorrect,
      widget.isSelected && widget.isWrong,
      borderRadius: 12.0,
      shadowBlurRadius: 2.0,
      shadowOffset: 2.0,
      defaultColor: theme.colorScheme.surface, // MODIFIED
      correctColor: theme.colorScheme.secondary, // MODIFIED
      wrongColor: theme.colorScheme.error, // MODIFIED
      border: Border.all(
        color: widget.isCorrect
            ? theme.colorScheme.secondary
            : (widget.isWrong
                ? theme.colorScheme.error
                : theme.colorScheme.onSurface.withValues(alpha:0.5)),
        width: 1, //MODIFIED
      ),
    );

    final buttonStyle = getButtonStyleForAnswer(
            widget.isSelected && widget.isCorrect,
            widget.isSelected && widget.isWrong,
            defaultColor: theme.colorScheme.surface, // MODIFIED
            correctColor: theme.colorScheme.secondary, // MODIFIED
            wrongColor: theme.colorScheme.error, // MODIFIED
            textColor: theme.colorScheme.onSurface) //MODIFIED
        .copyWith(
      elevation:
          WidgetStateProperty.all(0), // Remove elevation if not needed
    );

    Widget content;

    if (widget.isImageOption &&
        widget.data is Noun &&
        widget.data.image != null) {
      content = Image.memory(
        widget.data.image!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/placeholder_image.jpg',
          fit: BoxFit.cover,
        ),
      );
    } else {
      String text =
          (widget.data is Noun) ? widget.data.name : widget.data.toString();
      content = Center(
        child: Text(
          text,
          style: theme.textTheme.bodyLarge!.copyWith(
            //MODIFIED
            // MODIFIED: Using TextTheme
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface, // MODIFIED
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        widget.selectionNotifier.value = true;
        widget.onTap?.call();
      },
      child: Container(
        decoration: boxDecoration,
        child: widget.isImageOption
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: content,
              )
            : SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    widget.selectionNotifier.value = true;
                    widget.onTap?.call();
                  },
                  style: buttonStyle,
                  child: content,
                ),
              ),
      ),
    );
  }
}