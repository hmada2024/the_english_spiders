//lib/Learning_section/categories/nouns/nouns_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_bloc.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_events.dart';
import 'package:the_english_spiders/Learning/nouns/bloc/learn_noun_state.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/config/database_constants.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/core/ui/shared/custom_gradient.dart';
import 'package:the_english_spiders/core/ui/text/string_formatter.dart';
import 'package:the_english_spiders/main.dart';
import 'package:the_english_spiders/data/repositories/noun_repository.dart';
import 'package:the_english_spiders/core/ui/shared/category_filter.dart';
import 'package:the_english_spiders/core/ui/shared/category_title.dart';
import 'package:the_english_spiders/Learning/nouns/ui/noun_content.dart';

class NounsScreen extends StatelessWidget {
  static const routeName = AppRoutes.nouns;

  const NounsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getIt<NounRepository>().getAllCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
                child: Text("Error loading categories: ${snapshot.error}")),
          );
        }

        return BlocProvider<LearnNounBloc>(
          create: (context) => getIt<LearnNounBloc>()
            ..add(LoadNouns(category: Constants.categoryBird, context: context)),
          child: const _NounsPageView(),
        );
      },
    );
  }
}

class _NounsPageView extends StatelessWidget {
  const _NounsPageView();

  String _getTitle(String category) {
    return category == 'all'
        ? 'All Categories'
        : StringFormatter.formatFieldName(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Nouns',
        actions: [
          _buildCategoryFilter(context),
        ],
      ),
      body: CustomGradient(
        child: RefreshIndicator(
          onRefresh: () async {
            final selected =
                context.read<LearnNounBloc>().state.selectedCategory;
            context.read<LearnNounBloc>().add(LoadNouns(category: selected, context: context)); // Pass context here
          },
          child: Column(
            children: [
              BlocBuilder<LearnNounBloc, LearnNounState>(
                  builder: (context, state) {
                return CategoryTitle(title: _getTitle(state.selectedCategory));
              }),
              Expanded(
                child: BlocBuilder<LearnNounBloc, LearnNounState>(
                  builder: (context, state) {
                    return NounContent(
                      state: state,
                      onPlayAudio: (item) {
                        if (item.audio != null && item.audio!.isNotEmpty) {
                          context
                              .read<LearnNounBloc>()
                              .add(PlayNounAudio(item));
                        }
                      },
                      onRetry: () {
                        context
                            .read<LearnNounBloc>()
                            .add(LoadNouns(category: state.selectedCategory, context: context)); // Pass context here
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    // Receive context
    return BlocBuilder<LearnNounBloc, LearnNounState>(
        builder: (context, state) {
      final selected = state.selectedCategory;

      return CategoryFilterDropdown(
        categories: <String>['all', ...state.categories],
        selectedCategory: selected,
        onCategoryChanged: (String? newValue) {
          if (newValue != null) {
            context.read<LearnNounBloc>().add(LoadNouns(category: newValue, context: context)); // Pass context here
          }
        },
      );
    });
  }
}