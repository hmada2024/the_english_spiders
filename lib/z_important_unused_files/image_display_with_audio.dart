///Important: Do not delete it: This is an unused file,
/// but you will need it for a future quizzes///
library;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class ImageDisplayWithAudio extends StatelessWidget {
  final Uint8List? image;
  final Uint8List? audio;
  final VoidCallback onPlayAudio;
  final double width;
  final double height;

  const ImageDisplayWithAudio({
    super.key,
    required this.image,
    required this.audio,
    required this.onPlayAudio,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: audio != null ? onPlayAudio : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: EdgeInsets.all(width * 0.02),
            decoration: const BoxDecoration(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              child: SizedBox(
                width: width,
                height: height,
                child: image != null
                    ? Image.memory(
                        image!,
                        fit: BoxFit.cover,
                      )
                    : const Placeholder(),
              ),
            ),
          ),
        ),
        if (audio != null)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.volume_up,
              color: AppConstants.blueDark,
              size: AppConstants.iconSizeSmall,
            ),
          ),
      ],
    );
  }
}