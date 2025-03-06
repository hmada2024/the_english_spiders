part of 'learn_modal_semi_modal_verb_bloc.dart';

class LearnModalSemiModalVerbState extends Equatable {
  final List<ModalSemiModalVerb> modalSemiModalVerbs;
  final ModalSemiModalVerb? selectedModalSemiModalVerb;
  final bool isLoading;
  final String? error;
  final String? message;

  const LearnModalSemiModalVerbState({
    this.isLoading = false,
    this.error,
    this.message,
    this.modalSemiModalVerbs = const [],
    this.selectedModalSemiModalVerb,
  });

  LearnModalSemiModalVerbState copyWith({
    bool? isLoading,
    String? error,
    String? message,
    List<ModalSemiModalVerb>? modalSemiModalVerbs,
    ModalSemiModalVerb? selectedModalSemiModalVerb,
  }) {
    return LearnModalSemiModalVerbState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      modalSemiModalVerbs: modalSemiModalVerbs ?? this.modalSemiModalVerbs,
      selectedModalSemiModalVerb:
          selectedModalSemiModalVerb ?? this.selectedModalSemiModalVerb,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        message,
        modalSemiModalVerbs,
        selectedModalSemiModalVerb,
      ];
}