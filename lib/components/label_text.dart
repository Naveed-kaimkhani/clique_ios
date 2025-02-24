import 'package:clique/constants/app_colors.dart';
import 'package:flutter/material.dart';
class LabelText extends StatelessWidget {
  final String text;
  final FontWeight weight;
  final Theme? theme;
  final double? fontSize;
  final double? height;
  final TextOverflow? overflow;
  final int? maxLine;
  final Color textColor;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final Color? decorationColor;

  const LabelText({
    super.key,
    required this.text,
    this.overflow,
    this.theme,
    this.weight = FontWeight.normal,
    this.maxLine,
    this.fontSize=16,
    this.textAlign = TextAlign.start,
    this.textColor = AppColors.black,
    this.decoration = TextDecoration.none,
    this.decorationColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor,
        fontWeight: weight,
        fontSize: fontSize,
        decoration: decoration,
        decorationColor: decorationColor,
        height: height,
        // fontFamily: "ClashDisplay",
      ),
      overflow: overflow,
      maxLines: maxLine,
    );
  }
}