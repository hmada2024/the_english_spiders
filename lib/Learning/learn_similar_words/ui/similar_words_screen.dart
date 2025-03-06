// lib/Learning_section/screens/similar_words_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_bloc.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_event.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/bloc/learn_similar_words_state.dart';
import 'package:the_english_spiders/Learning/learn_similar_words/ui/similar_word_card.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/main.dart';

class SimilarWordsScreen extends StatelessWidget {
  static const routeName = AppRoutes.similarWords;

  const SimilarWordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LearnSimilarWordsBloc>(
      create: (context) => getIt<LearnSimilarWordsBloc>()..add(LoadSimilarWords()),
      child: const SimilarWordsView(),
    );
  }
}

class SimilarWordsView extends StatelessWidget {
  const SimilarWordsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Similar Words'),
      body: RefreshIndicator( // For pull-to-refresh
        onRefresh: () async {
          context.read<LearnSimilarWordsBloc>().add(LoadSimilarWords());
        },
        child: BlocBuilder<LearnSimilarWordsBloc, LearnSimilarWordsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error != null) {
                return ErrorDisplay(
                    errorMessage: state.error!,
                    onRetry: () {
                    context
                        .read<LearnSimilarWordsBloc>()
                        .add(LoadSimilarWords());
                    });
            }
            return ListView.builder(
              itemCount: state.seedsWithBranches.length,
              itemBuilder: (context, index) =>
                  SimilarWordCard(seedWithBranches: state.seedsWithBranches[index]),
            );
          },
        ),
      ),
    );
  }
}