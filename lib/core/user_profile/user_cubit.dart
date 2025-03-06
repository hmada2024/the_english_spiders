//lib/core/user/user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/user_profile/user_state.dart';
import 'package:the_english_spiders/data/models/user_model.dart';
import 'package:the_english_spiders/data/repositories/user_repository.dart';  // Import UserRepository
import 'package:flutter/foundation.dart';

class UserCubit extends Cubit<UserState> {
    final UserRepository _userRepository;

    UserCubit(this._userRepository) : super(const UserState());

Future<void> submitAuthForm({
    required String name,
    required String password,
    required bool isLoginMode,
    String? gender,
}) async {
  debugPrint("UserCubit: submitAuthForm called (isLoginMode: $isLoginMode)"); 
  try {
    emit(state.copyWith(isLoading: true, error: null, user: null));

    if (isLoginMode) {
      // Login
      final user = await _userRepository.getUserByUsername(name);
      if (user != null && user.password == password) {
        emit(state.copyWith(user: user, isLoading: false));
      } else {
        emit(state.copyWith(
            error: 'Login failed: Incorrect username or password.',
            isLoading: false,
        ));
      }
    } else {
      // Registration
      if (name.isNotEmpty && password.isNotEmpty && gender != null) {
        final newUser = UserModel(
            name: name,
            password: password,
            gender: gender,
            creationDate: DateTime.now().toString());

        final newUserId = await _userRepository.insertUser(newUser); // Insert and get ID
        final userWithId = newUser.copyWith(id: newUserId); // Update with the new ID
        emit(state.copyWith(user: userWithId, isLoading: false));
      } else {
          emit(state.copyWith(
          error: 'Registration failed: Incomplete data.',
          isLoading: false));
      }
    }
  } catch (e) {
    debugPrint("Error in submitAuthForm: $e");
    emit(state.copyWith(isLoading: false, error: e.toString()));
  }
}

  Future<void> updateUser(UserModel updatedUser) async {
      debugPrint("UserCubit: updateUser called (updatedUser: $updatedUser)"); // أضف هنا
    emit(state.copyWith(isLoading: true, error: null));
    try {
          await _userRepository.updateUser(updatedUser); // Update in the database
          emit(state.copyWith(user: updatedUser, isLoading: false));

    } catch (e) {
        debugPrint("Error in updateUser: $e");
      emit(state.copyWith(isLoading: false, error: 'Failed to update user: $e'));
    }

  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}