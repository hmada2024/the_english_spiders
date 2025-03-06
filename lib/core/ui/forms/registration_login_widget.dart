//lib/core/widgets/input/registration_login_widget.dart
import 'package:the_english_spiders/core/screens/profile_screen.dart';
import 'package:the_english_spiders/core/user_profile/user_cubit.dart';
import 'package:the_english_spiders/core/user_profile/user_state.dart';
import 'package:the_english_spiders/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/app_constants.dart'; // Import AppConstants
import 'package:the_english_spiders/core/ui/forms/custom_text_field.dart';

class RegistrationLoginWidget extends StatefulWidget {
  final Function(UserModel user)? onLoginSuccess;

  const RegistrationLoginWidget({super.key, this.onLoginSuccess});

  @override
  State<RegistrationLoginWidget> createState() =>
      _RegistrationLoginWidgetState();
}

class _RegistrationLoginWidgetState extends State<RegistrationLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _gender = 'male';
  bool _isLoginMode = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String password = _passwordController.text.trim();

      BlocProvider.of<UserCubit>(context).submitAuthForm(
        name: name,
        password: password,
        isLoginMode: _isLoginMode,
        gender: _isLoginMode ? null : _gender,
      );
    }
  }

  void _performNavigation(UserState state) {
    if (state.user != null) {
      widget.onLoginSuccess?.call(state.user!);
      Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth =
        MediaQuery.of(context).size.width; // للحصول على عرض الشاشة
    final buttonPadding = screenWidth * 0.04; // حشوة ديناميكية
    final buttonFontSize = screenWidth * 0.045; // حجم خط ديناميكي
    final titleFontSize = screenWidth * 0.06;
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.user != null) {
          _performNavigation(state);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          title: Text(
            _isLoginMode ? 'Login' : 'Register',
            style: theme.textTheme.displayMedium!
                .copyWith(fontSize: titleFontSize), // حجم خط أكبر
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: state.error != null
                          ? Container(
                              key: const ValueKey('errorContainer'),
                              margin: const EdgeInsets.only(bottom: 16.0),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error
                                    .withValues(alpha:0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline,
                                      color: theme.colorScheme.error),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      state.error!,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                              color: theme.colorScheme.error),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(key: ValueKey('noError')),
                    ),
                    CustomTextField(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icons.person_outline,
                      controller: _nameController,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter your username'
                          : null,
                    ),

                    const SizedBox(height: AppConstants.marginMedium),

                    // Password field
                    CustomTextField(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                        suffixIcon:
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        onSuffixIconPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                      },
                      validator: (value) =>
                          !_isLoginMode && (value == null || value.isEmpty)
                              ? 'Please enter your password'
                              : null,
                    ),

                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1.0,
                          child:
                              FadeTransition(opacity: animation, child: child),
                        );
                      },
                      child: !_isLoginMode
                          ? Padding(
                              key: const ValueKey('genderRadios'),
                              padding:  const EdgeInsets.only(top: AppConstants.marginMedium),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Gender',
                                      style: theme.textTheme.bodyLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'male',
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        },
                                        activeColor:
                                            theme.colorScheme.secondary,
                                      ),
                                      Text('Male',
                                          style: theme.textTheme.bodyMedium),
                                      Radio<String>(
                                        value: 'female',
                                        groupValue: _gender,
                                        onChanged: (value) {
                                          setState(() {
                                            _gender = value!;
                                          });
                                        },
                                        activeColor:
                                            theme.colorScheme.secondary,
                                      ),
                                      Text('Female',
                                          style: theme.textTheme.bodyMedium),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: AppConstants.marginLarge),
                    ElevatedButton(
                      onPressed: state.isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppConstants.primaryColor, // لون الخلفية
                        foregroundColor:
                            AppConstants.textColorLight, // لون النص
                        padding: EdgeInsets.symmetric(
                            vertical: buttonPadding), // حشوة ديناميكية
                        textStyle: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.bold), // حجم خط ديناميكي
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium),
                        ),
                        elevation: AppConstants.defaultElevation,
                      ).copyWith(
                        overlayColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.pressed)) {
                              return AppConstants.accentColor
                                  .withValues(alpha: 0.5);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: state.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : Text(_isLoginMode ? 'Login' : 'Register'),
                    ),
                    const SizedBox(height: AppConstants.marginMedium),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoginMode = !_isLoginMode;
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.secondary,
                        ),
                        child: Text(
                          _isLoginMode
                              ? 'Don\'t have an account? Register'
                              : 'Already have an account? Login',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}