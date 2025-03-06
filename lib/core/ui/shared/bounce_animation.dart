//lib/core/widgets/shared/bounce_animation.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double scaleDownTo;
  final VoidCallback? onTap;

  const BounceAnimation({
    super.key,
    required this.child,
    this.duration = AppConstants.animationDurationShort,
    this.scaleDownTo = 0.95,
    this.onTap,
  });

  @override
  BounceAnimationState createState() => BounceAnimationState();
}

class BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleDownTo).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

    Future<void> _animate() async { // extracted to a method
    if (!mounted) return; // crucial check.
    await _controller.forward(from: 0.0);
    await _controller.reverse();
     if (widget.onTap != null && mounted) {
      widget.onTap!(); // Call onTap if provided
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Use GestureDetector
      onTap: _animate,
          child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}