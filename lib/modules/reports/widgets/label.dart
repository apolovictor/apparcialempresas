import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  const Label({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
          fontFamily: 'din-pro',
        );
    return Text(
      label,
      style: style,
      textAlign: TextAlign.right,
    );
  }
}
