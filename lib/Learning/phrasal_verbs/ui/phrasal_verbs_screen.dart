import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/phrasal_verbs/bloc/learn_phrasal_verb_bloc.dart';
import 'package:the_english_spiders/Learning/phrasal_verbs/ui/phrasal_verb_card.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/main.dart';

class PhrasalVerbsScreen extends StatelessWidget {
  static const routeName = AppRoutes.phrasalVerbs; // Added route name
  const PhrasalVerbsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LearnPhrasalVerbBloc>(
      create: (context) => getIt<LearnPhrasalVerbBloc>()..add(LoadPhrasalVerbs()),
      child: const PhrasalVerbsView(),
    );
  }
}

class PhrasalVerbsView extends StatelessWidget {
  const PhrasalVerbsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Phrasal Verbs',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<LearnPhrasalVerbBloc>().add(LoadPhrasalVerbs());
        },
        child: BlocBuilder<LearnPhrasalVerbBloc, LearnPhrasalVerbState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.error != null) {
              return ErrorDisplay(
                errorMessage: state.error!,
                onRetry: () =>
                    context.read<LearnPhrasalVerbBloc>().add(LoadPhrasalVerbs()),
              );
            }
            if (state.phrasalVerbs.isEmpty) {
              return const Center(child: Text("No phrasal verbs found."));
            }

            return ListView.builder(
              itemCount: state.phrasalVerbs.length,
              itemBuilder: (context, index) {
                return PhrasalVerbCard(phrasalVerb: state.phrasalVerbs[index]);
              },
            );
          },
        ),
      ),
    );
  }
}