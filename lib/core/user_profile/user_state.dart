//lib/core/user/user_state.dart
import 'package:equatable/equatable.dart';
import 'package:the_english_spiders/data/models/user_model.dart';

class UserState extends Equatable {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const UserState({this.user, this.isLoading = false, this.error});

  UserState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, error];
}
