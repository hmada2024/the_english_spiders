//lib/core/widgets/item_card/item_details.dart
import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  final List<Widget> rows;

  const ItemDetails({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }
}