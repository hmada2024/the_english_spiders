// lib/shared/widgets/custom_gradient.dart
import 'package:flutter/material.dart';

class CustomGradient extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const CustomGradient({
    super.key,
    required this.child,
    this.colors = const [Color(0xFF00C9FF), Color(0xFF92FE9D)],
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
