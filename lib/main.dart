//lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:the_english_spiders/core/config/app_routes.dart';
import 'package:the_english_spiders/core/di/app_dependencies.dart' as di;
import 'package:the_english_spiders/core/di/app_blocs.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/core/theme/theme_cubit.dart';
import 'package:the_english_spiders/core/theme/theme_state.dart';
import 'dart:io' show Platform;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await di.setupDependencies();

  runApp(const MyApp());
  getIt<AudioService>().dispose();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: createBlocProviders(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Learning Spiders',
            theme: state.themeData,
            themeMode: ThemeMode.system,
            initialRoute: AppRoutes.mainScreen,
            routes: AppRoutes.getRoutes(),
          );
        },
      ),
    );
  }
}
