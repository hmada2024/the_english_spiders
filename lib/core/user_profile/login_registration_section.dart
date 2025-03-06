//lib/core/widgets/profile/login_registration_section.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/data/models/user_model.dart';
import 'package:the_english_spiders/core/ui/shared/custom_button.dart';
import 'package:the_english_spiders/core/ui/forms/registration_login_widget.dart';
import 'package:the_english_spiders/core/config/button_styles.dart';

class LoginRegistrationSection extends StatelessWidget {
  final Function(UserModel user)? onLoginSuccess;
  const LoginRegistrationSection({super.key, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You are not logged in!",
            style: theme.textTheme.titleLarge!
                .copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: AppConstants.marginMedium),
          CustomButton(
            labelText: "Login/Register",
            style: ButtonStyles.primaryStyle(context),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return RegistrationLoginWidget(
                        onLoginSuccess: onLoginSuccess);
                  });
            },
          ),
        ],
      ),
    );
  }
}