//lib/core/widgets/shared/audio_button.dart
import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  final double iconSize;
  final VoidCallback? onPressed;

  const AudioButton({super.key, required this.iconSize, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.volume_up,
        color: theme.colorScheme.primary,
        size: iconSize,
      ),
      onPressed: onPressed,
    );
  }
}