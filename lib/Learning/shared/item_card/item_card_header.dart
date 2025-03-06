//lib/Learning/shared/item_card/item_card_header.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';
import 'package:the_english_spiders/core/ui/shared/bounce_animation.dart';
import 'package:the_english_spiders/main.dart';
import 'package:the_english_spiders/core/services/audio_service.dart';

class ItemCardHeader<T> extends StatelessWidget {
  final T item;
  final bool isExpanded;
  final VoidCallback onTap;
  final String Function(T) displayValue;
  final Uint8List? Function(T)? audioData;
  final Color? backgroundColor;
  final Color? textColor;

  const ItemCardHeader({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.onTap,
    required this.displayValue,
    this.audioData,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audio = audioData?.call(item);
    final hasAudio = audio != null && audio.isNotEmpty;
    final displayValueText = displayValue(item);

    return BounceAnimation(
      onTap: () async {
        if (!hasAudio) return;
        final audioService = getIt<AudioService>();
        await audioService.start(audio);
      },
      child: Container(
        padding:  const EdgeInsets.all(AppConstants.paddingExtraSmall),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Text( // استخدم Text بدلاً من StyledText
          displayValueText,
          style: theme.textTheme.headlineSmall!.copyWith( // استخدم نمط خط من الثيم
            color: textColor ?? theme.colorScheme.primary, // استخدم لونًا من الثيم أو اللون المخصص
          ),
        ),
      ),
    );
  }
}