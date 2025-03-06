//lib/core/widgets/settings/settings_option.dart
import 'package:flutter/material.dart';

class SettingsOption extends StatelessWidget {
  final Widget child;

  const SettingsOption({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        const Divider(height: 1, thickness: 1, color: Colors.grey)
      ],
    );
  }
}