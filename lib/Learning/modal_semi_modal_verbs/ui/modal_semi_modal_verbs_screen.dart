import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/Learning/modal_semi_modal_verbs/bloc/learn_modal_semi_modal_verb_bloc.dart';
import 'package:the_english_spiders/Learning/modal_semi_modal_verbs/ui/modal_semi_modal_verb_card.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/ui/shared/custom_app_bar.dart';
import 'package:the_english_spiders/core/ui/shared/error_display.dart';
import 'package:the_english_spiders/main.dart';

class ModalSemiModalVerbsScreen extends StatelessWidget {
  static const routeName = AppRoutes.modalSemiModalVerbs; // Add route name
  const ModalSemiModalVerbsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LearnModalSemiModalVerbBloc>(
      create: (context) => getIt<LearnModalSemiModalVerbBloc>()
        ..add(LoadModalSemiModalVerbs()),
      child: const ModalSemiModalVerbsView(),
    );
  }
}

class ModalSemiModalVerbsView extends StatelessWidget {
  const ModalSemiModalVerbsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 
  '''Modal and Semi Modal
              Verbs''',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context
              .read<LearnModalSemiModalVerbBloc>()
              .add(LoadModalSemiModalVerbs());
        },
        child:
            BlocBuilder<LearnModalSemiModalVerbBloc, LearnModalSemiModalVerbState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.error != null) {
              return ErrorDisplay(
                errorMessage: state.error!,
                onRetry: () => context
                    .read<LearnModalSemiModalVerbBloc>()
                    .add(LoadModalSemiModalVerbs()),
              );
            }
            if (state.modalSemiModalVerbs.isEmpty) {
              return const Center(
                  child: Text("No modal/semi-modal verbs found."));
            }

            return ListView.builder(
              itemCount: state.modalSemiModalVerbs.length,
              itemBuilder: (context, index) {
                return ModalSemiModalVerbCard(
                    modalSemiModalVerb: state.modalSemiModalVerbs[index]);
              },
            );
          },
        ),
      ),
    );
  }
}