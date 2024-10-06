import 'package:flashcard_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class DisplayHeading extends StatelessWidget {
  const DisplayHeading(
      {super.key,
      required this.text,
      this.fontWeight = FontWeight.bold,
      this.fontSize = 24,
      this.color = Colors.black, 
      this.textAlign = TextAlign.left
    });
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Text(
      text,
      textAlign: textAlign,
      style: textTheme.bodyMedium
          ?.copyWith(fontWeight: fontWeight, fontSize: fontSize, color: color),
    );
  }
}