//lib/Learning_section/categories/verb_conjugations/verb_list.dart
// lib/Learning_section/categories/verb_conjugations/verb_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_event.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_state.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/ui/verb_card.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';

class VerbList extends StatelessWidget {
  const VerbList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearnVerbConjugationsBloc, LearnVerbConjugationsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          );
        }
        if (state.error != null) {
          return ErrorDisplay(
            errorMessage: state.error!,
            onRetry: () {
              final currentState =
                  context.read<LearnVerbConjugationsBloc>().state;
              context.read<LearnVerbConjugationsBloc>().add(
                    LoadVerbs(verbType: currentState.selectedVerbType),
                  );
            },
          );
        }

        if (state.verbs.isEmpty) {
          return const Center(child: Text("No verbs found."));
        }

        return ListView.builder(
          itemCount: state.verbs.length,
          itemBuilder: (context, index) {
            return VerbCard(verb: state.verbs[index]);
          },
        );
      },
    );
  }
}