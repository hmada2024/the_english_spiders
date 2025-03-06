// lib/Learning_section/screens/verb_conjugations_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_bloc.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_event.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/bloc/verb_conjugations_state.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/shared/category_filter.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/main.dart';
import 'package:the_english_spiders/Learning/verb_conjugations/ui/verb_list.dart';
import 'package:the_english_spiders/core/ui/shared/category_title.dart';

class VerbConjugationsScreen extends StatelessWidget {
  const VerbConjugationsScreen({super.key});
  static const routeName = AppRoutes.verbConjugationQuiz;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LearnVerbConjugationsBloc>(
      create: (context) => getIt<LearnVerbConjugationsBloc>()
        ..add(const LoadVerbs(verbType: 'irregular')),
      child: const VerbConjugationsView(),
    );
  }
}

class VerbConjugationsView extends StatelessWidget {
  const VerbConjugationsView({super.key});

  String _getTitle(String? verbType) {
    if (verbType == 'regular') {
      return 'Regular Verbs';
    } else if (verbType == 'irregular') {
      return 'Irregular Verbs';
    } else {
      return 'All Verbs';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Verb Conjugations',
        actions: [
          _buildCategoryFilter(context),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final currentState = context.read<LearnVerbConjugationsBloc>().state;
          context.read<LearnVerbConjugationsBloc>().add(
                LoadVerbs(verbType: currentState.selectedVerbType),
              );
        },
        child: Column(
          children: [
            CategoryTitle(
              title: _getTitle(
                context.watch<LearnVerbConjugationsBloc>().state.selectedVerbType,
              ),
            ),
            const Expanded(
              child: VerbList(),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildCategoryFilter(BuildContext context) {
    return BlocBuilder<LearnVerbConjugationsBloc, LearnVerbConjugationsState>(
      builder: (context, state) {
        return CategoryFilterDropdown(
          categories: const ['all', 'regular', 'irregular'],
          selectedCategory: state.selectedVerbType ?? 'irregular',
          onCategoryChanged: (newValue) {
            context
                .read<LearnVerbConjugationsBloc>()
                .add(LoadVerbs(verbType: newValue));
          },
        );
      },
    );
  }
}
