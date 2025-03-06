import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class ImageSection extends StatelessWidget { // أصبح StatelessWidget
  final Uint8List? imageBytes;
  final double width;
  final double? height;
  final Widget? placeholder;

  const ImageSection({
    super.key,
    required this.imageBytes,
    required this.width,
    this.height,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    if (imageBytes == null) {
      return placeholder ?? _defaultPlaceholder();
    }

    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.memory(
          imageBytes!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _defaultPlaceholder() {
    return SizedBox(
      width: width,
      height: height ?? width,
      child: Container(
        color: AppConstants.greyColor,
        child: Icon(
          Icons.image_not_supported,
          size: width * 0.3,
          color: AppConstants.textColorDark,
        ),
      ),
    );
  }
}