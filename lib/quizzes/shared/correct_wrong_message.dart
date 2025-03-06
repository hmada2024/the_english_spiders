// lib/quizzes/shared/correct_wrong_message.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/app_constants.dart';

class CorrectWrongMessage extends StatefulWidget {
  final bool isCorrect;
  final double correctTextSize;

  const CorrectWrongMessage({
    super.key,
    required this.isCorrect,
    required this.correctTextSize,
  });

  @override
  State<CorrectWrongMessage> createState() => _CorrectWrongMessageState();
}

class _CorrectWrongMessageState extends State<CorrectWrongMessage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: widget.isCorrect 
                  ? AppConstants.correctColor.withValues(alpha: 0.1)
                  : AppConstants.wrongColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: widget.isCorrect
                    ? AppConstants.correctColor
                    : AppConstants.wrongColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: (widget.isCorrect 
                      ? AppConstants.correctColor
                      : AppConstants.wrongColor).withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.isCorrect ? Icons.check_circle : Icons.cancel,
                  color: widget.isCorrect 
                      ? AppConstants.correctColor
                      : AppConstants.wrongColor,
                  size: widget.correctTextSize * 1.2,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isCorrect ? 'Correct!' : 'Wrong!',
                  style: TextStyle(
                    color: widget.isCorrect 
                        ? AppConstants.correctColor 
                        : AppConstants.wrongColor,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    fontSize: widget.correctTextSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}