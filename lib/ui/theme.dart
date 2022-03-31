import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';

import 'colors.dart';

class LuraTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      appBarTheme: _appBarTheme,
      // inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      scaffoldBackgroundColor: Colors.white,
      dividerTheme: _dividerTheme,
      textTheme: _textTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      headline1: LuraTextStyles.heading1,
      headline2: LuraTextStyles.heading2,
      headline3: LuraTextStyles.heading3,
      headline4: LuraTextStyles.heading4,
      headline5: LuraTextStyles.heading5,
      bodyText1: LuraTextStyles.largeParagraph,
      bodyText2: LuraTextStyles.paragraph,
      subtitle1: LuraTextStyles.paragraphSmall,
      subtitle2: LuraTextStyles.paragraphSmallest,
    );
  }

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: LuraColors.blue),
    );
  }

  // ignore: unused_element
  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: LuraColors.inputBorderBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: LuraColors.inputBorderError),
      ),
      hoverColor: Colors.white,
      hintStyle: LuraTextStyles.paragraph
          .copyWith(color: LuraColors.inputPlaceholderColor),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        primary: LuraColors.blue,
        minimumSize: const Size(80, 30),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: LuraColors.blue,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        textStyle: LuraTextStyles.paragraphSmall,
      ),
    );
  }

  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: LuraColors.divider,
      thickness: 1,
    );
  }
}
