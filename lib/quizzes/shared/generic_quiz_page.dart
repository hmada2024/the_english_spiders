//lib/quizzes/shared/generic_quiz_page.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/ui/shared/custom_gradient.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';

class GenericQuizPage extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final Widget content;
  final Widget? floatingActionButton;

  const GenericQuizPage({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
    required this.content,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomGradient(
          child: SizedBox.expand(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: title,
            leading: leading,
            actions: actions,
          ),
          floatingActionButton: floatingActionButton,
          body: content,
        ),
      ],
    );
  }
}