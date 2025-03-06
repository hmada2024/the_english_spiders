// lib/Learning_section/blocs/learn_adjective/learn_adjective_event.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/adjective_model.dart';
import 'package:the_english_spiders/core/ui/shared/audio_type.dart';

abstract class LearnAdjectiveEvent extends Equatable {
  const LearnAdjectiveEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllAdjectives extends LearnAdjectiveEvent {}

class SelectAdjective extends LearnAdjectiveEvent {
  final Adjective adjective;
  const SelectAdjective(this.adjective);

  @override
  List<Object?> get props => [adjective]; //  مهم لـ Equatable
}

class PlayAdjectiveAudio extends LearnAdjectiveEvent {
  final Adjective adjective;
  final AudioType audioType; // Use enum
  const PlayAdjectiveAudio({required this.adjective, required this.audioType});

  @override
  List<Object?> get props => [adjective, audioType];
}