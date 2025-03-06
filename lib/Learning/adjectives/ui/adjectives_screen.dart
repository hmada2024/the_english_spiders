//lib/Learning_section/categories/adjectives/adjectives_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_bloc.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_event.dart';
import 'package:the_english_spiders/Learning/adjectives/bloc/learn_adjective_state.dart';
import 'package:the_english_spiders/Learning/adjectives/ui/adjective_card.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/main.dart';

class AdjectivesScreen extends StatelessWidget {
  static const routeName = AppRoutes.adjectives;

  const AdjectivesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LearnAdjectiveBloc>(
      create: (context) =>
          getIt<LearnAdjectiveBloc>()..add(LoadAllAdjectives()),
      child: const AdjectivesView(),
    );
  }
}

class AdjectivesView extends StatelessWidget {
  const AdjectivesView({super.key});

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Adjectives'),
      body:  Container(
        color: theme.colorScheme.surface,
        child: RefreshIndicator(
          onRefresh: () async =>
              context.read<LearnAdjectiveBloc>().add(LoadAllAdjectives()),
          child: BlocBuilder<LearnAdjectiveBloc, LearnAdjectiveState>(
            builder: (context, state) {
              if (state.isLoading) {
                return  Center(
                    child: CircularProgressIndicator(
                        color: theme.colorScheme.primary));
              }

              if (state.error != null) {
                return ErrorDisplay(
                  errorMessage: state.error!,
                  onRetry: () => context
                      .read<LearnAdjectiveBloc>()
                      .add(LoadAllAdjectives()),
                );
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          AdjectiveCard(adjective: state.adjectives[index]),
                      childCount: state.adjectives.length,
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