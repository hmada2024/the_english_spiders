//lib/core/widgets/shared/responsive_grid_view.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/screen_size.dart';

class ResponsiveGridView extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;
  final double childAspectRatio;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;

    const ResponsiveGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.childAspectRatio = 1.0, // Default aspect ratio
      this.mainAxisSpacing,
      this.crossAxisSpacing
  });


  @override
  Widget build(BuildContext context) {
    final screenWidth = ScreenSize.getWidth(context);
    final crossAxisCount =
        ScreenSize.isTablet(context) ? 3 : (screenWidth > 600 ? 2 : 1);

    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing ?? 0.0, // Use provided or default 0
        crossAxisSpacing: crossAxisSpacing ?? 0.0,  // Use provided or default 0
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}