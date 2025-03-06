//lib/core/widgets/item_card/item_detail_row.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/Learning/shared/item_card/audio_button.dart';
import 'package:the_english_spiders/core/ui/shared/bounce_animation.dart';
import 'package:the_english_spiders/main.dart';
import 'dart:typed_data';
import 'package:the_english_spiders/core/services/audio_service.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class ItemDetailRow extends StatefulWidget {
  final String? title;
  final String? value;
  final InlineSpan? richValue;
  final Uint8List? audio;
  final Color? rowColor;
  final Function(Uint8List)? onPlayAudio;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final EdgeInsets? padding;
  final double? iconSize;
  final BorderRadius? borderRadius;

  const ItemDetailRow({
    super.key,
    this.title,
    this.value,
    this.richValue,
    this.audio,
    this.rowColor,
    this.onPlayAudio,
    this.titleStyle,
    this.valueStyle,
    this.padding,
    this.iconSize,
    this.borderRadius,
  });

  @override
  State<ItemDetailRow> createState() => _ItemDetailRowState();
}

class _ItemDetailRowState extends State<ItemDetailRow> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = widget.iconSize ?? 24.0;
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(vertical: AppConstants.paddingExtraSmall),
      child: BounceAnimation(
        onTap: () {
          if (widget.audio != null && widget.audio!.isNotEmpty && mounted) {
            final audioService = getIt<AudioService>();
            audioService.start(widget.audio!);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingSmall),
          decoration: BoxDecoration(
            color: widget.rowColor ?? theme.colorScheme.surface,
            borderRadius: widget.borderRadius ??
                BorderRadius.circular(AppConstants.borderRadiusMedium),
          ),
          child: Row(
            children: [
              if (widget.title != null) ...[
                Expanded(
                  child: Text(
                    '${widget.title!}: ',
                    style: widget.titleStyle ??
                        theme.textTheme.bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (widget.value != null && widget.value!.isNotEmpty)
                  Expanded(
                    child: Text(
                      widget.value!,
                      style: widget.valueStyle ?? theme.textTheme.bodyMedium,
                    ),
                  )
                else if (widget.richValue != null)
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: widget.valueStyle ?? theme.textTheme.bodyMedium,
                        children: [widget.richValue!],
                      ),
                    ),
                  ),
              ] else if (widget.value != null && widget.value!.isNotEmpty)
                Expanded(
                  child: Text(
                    widget.value!,
                    style: widget.valueStyle ?? theme.textTheme.bodyMedium,
                  ),
                )
              else if (widget.richValue != null)
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: widget.valueStyle ?? theme.textTheme.bodyMedium,
                      children: [widget.richValue!],
                    ),
                  ),
                ),
              if (widget.audio != null)
                AudioButton(
                    iconSize: iconSize,
                    onPressed: () {
                      if (widget.audio != null &&
                          widget.audio!.isNotEmpty &&
                          mounted) {
                        final audioService = getIt<AudioService>();
                        audioService.start(widget.audio!);
                      }
                    })
            ],
          ),
        ),
      ),
    );
  }
}