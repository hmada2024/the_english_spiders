//lib/core/screens/main_screen.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/screens/learning_home_screen.dart';
import 'package:the_english_spiders/core/screens/quizzes_home_screen.dart';
import 'package:the_english_spiders/core/screens/games_home_screen.dart'; // Import GamesHomeScreen
import 'package:the_english_spiders/core/screens/settings_screen.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void navigateToIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  late final List<Widget> _pages = [
    const LearningHomeScreen(),
    const QuizzesHomeScreen(),
    const GamesHomeScreen(),
    const SettingsScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz),
            label: 'Quizzes',
          ),
          NavigationDestination(
            icon: Icon(Icons.games_outlined),
            selectedIcon: Icon(Icons.games),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.8),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: AppConstants.animationDurationLong,
        elevation: 4,
      ),
    );
  }
}