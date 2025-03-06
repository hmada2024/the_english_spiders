//lib/Learning_section/screens/compound_words_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_bloc.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_event.dart';
import 'package:the_english_spiders/Learning/compound_words/bloc/learn_compound_word_state.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/Learning/compound_words/ui/compound_word_card.dart';
import 'package:the_english_spiders/main.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart'; // Import

class CompoundWordsScreen extends StatelessWidget {
  static const routeName = AppRoutes.compoundWords;

  const CompoundWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LearnCompoundWordBloc>(
      create: (context) =>
          getIt<LearnCompoundWordBloc>()..add(const LoadCompoundWords()),
      child: const CompoundWordsView(),
    );
  }
}

class CompoundWordsView extends StatelessWidget {
  const CompoundWordsView({super.key});

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Compound Words'),
      body: Container(
              color: theme.colorScheme.surface,
        child: RefreshIndicator(
          onRefresh: () async {
            context
                .read<LearnCompoundWordBloc>()
                .add(const LoadCompoundWords());
          },
          child:
              BlocBuilder<LearnCompoundWordBloc, LearnCompoundWordState>(
            builder: (context, state) {
              if (state.isLoading) {
                return  Center(
                    child: CircularProgressIndicator(
                        color: theme.colorScheme.primary));
              }
              if (state.error != null) {
                return ErrorDisplay(
                    errorMessage: state.error!,
                    onRetry: () {
                      context
                          .read<LearnCompoundWordBloc>()
                          .add(const LoadCompoundWords());
                    });
              }
              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CompoundWordCard(
                          compoundWord: state.compoundWords[index]),
                      childCount: state.compoundWords.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}