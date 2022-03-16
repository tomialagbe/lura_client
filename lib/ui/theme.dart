import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';

import 'colors.dart';

class LuraTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      appBarTheme: _appBarTheme,
      inputDecorationTheme: _inputDecorationTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      textButtonTheme: _textButtonTheme,
      scaffoldBackgroundColor: Colors.white,
      dividerTheme: _dividerTheme,
    );
  }

  static AppBarTheme get _appBarTheme {
    return const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: LuraColors.blue),
    );
  }

  static InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: LuraColors.inputColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: LuraTextStyles.baseTextStyle.copyWith(fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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

  static ElevatedButtonThemeData get invertedElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        primary: Colors.white,
        splashFactory: InkRipple.splashFactory,
        minimumSize: const Size(80, 30),
      ),
    );
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: LuraColors.blue,
        padding: const EdgeInsets.symmetric(vertical: 10),
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
