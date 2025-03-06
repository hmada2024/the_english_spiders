// lib/core/theme/theme_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ThemeState extends Equatable {
  final ThemeData themeData;
  const ThemeState(this.themeData);

  @override
  List<Object?> get props => [themeData];
}

class ThemeLight extends ThemeState {
  const ThemeLight(super.themeData);
}

class ThemeDark extends ThemeState {
  const ThemeDark(super.themeData);
}
