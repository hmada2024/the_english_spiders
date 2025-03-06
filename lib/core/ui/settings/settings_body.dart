import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';
import 'package:the_english_spiders/core/theme/theme_cubit.dart';
import 'package:the_english_spiders/core/theme/theme_state.dart';
import 'package:the_english_spiders/core/ui/settings/settings_card.dart';
import 'package:the_english_spiders/core/ui/settings/settings_option.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: AppConstants.animationDurationMedium,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final screenHeight = ScreenSize.getHeight(context);
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.03,
      ),
      child: ListView(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _animationController,
              child: SettingsCard(
                // Using the new widget
                children: [
                  SettingsOption(
                    // Using the new Settings option
                    child: ListTile(
                      leading:  Icon(Icons.language, color: theme.colorScheme.primary,),
                      title:  Text('Change Language', style: theme.textTheme.bodyLarge,),
                      onTap: () {},
                    ),
                  ),
                  SettingsOption(
                    child: SwitchListTile(
                      title:  Text('Dark Mode', style: theme.textTheme.bodyLarge,),
                      value: context.watch<ThemeCubit>().state is ThemeDark,
                      onChanged: (bool value) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      activeColor: theme.colorScheme.secondary,
                      secondary: Icon(
                        context.read<ThemeCubit>().state is ThemeDark
                            ? Icons.nightlight_round
                            : Icons.wb_sunny,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.marginMedium),
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _animationController,
              child: SettingsCard(
                // Using the new widget
                children: [
                  SettingsOption(
                      child: ListTile(
                    leading:  Icon(Icons.info_outline, color: theme.colorScheme.primary,),
                    title:  Text('App Information', style: theme.textTheme.bodyLarge,),
                    onTap: () {},
                  )),
                  SettingsOption(
                      child: ListTile(
                    leading:  Icon(Icons.share, color: theme.colorScheme.primary),
                    title:  Text('Share App',style: theme.textTheme.bodyLarge,),
                    onTap: () {},
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}