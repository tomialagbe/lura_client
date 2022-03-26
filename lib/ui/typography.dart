import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class LuraTextStyles {
  static const baseTextStyle = TextStyle(
    fontFamily: 'Inter',
    color: Colors.black,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static final heading1 =
      baseTextStyle.copyWith(fontSize: 140, fontWeight: FontWeight.w700);

  static final heading2 =
      baseTextStyle.copyWith(fontSize: 95, fontWeight: FontWeight.w700);

  static final heading3 =
      baseTextStyle.copyWith(fontSize: 43, fontWeight: FontWeight.w700);

  static final heading4 =
      baseTextStyle.copyWith(fontSize: 29, fontWeight: FontWeight.w700);

  static final heading5 =
      baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w700);

  static final largeParagraph =
      baseTextStyle.copyWith(fontSize: 29, fontWeight: FontWeight.w400);

  static final paragraph =
      baseTextStyle.copyWith(fontSize: 22, fontWeight: FontWeight.w400);

  static final paragraphSmall =
      baseTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w400);

  static final paragraphSmallest =
      baseTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400);

  static final eyebrow =
      baseTextStyle.copyWith(fontSize: 29, fontWeight: FontWeight.w500);

  static final link =
      baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600);

  static final actionButton =
      baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w400);
}
