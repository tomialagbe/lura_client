import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';

import '../colors.dart';
import 'text_input_validator.dart';

class LuraTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputValidator? textInputValidator;
  final Widget? trailing;
  final bool large;

  const LuraTextField({
    Key? key,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.textInputValidator,
    this.trailing,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(inputDecorationTheme: _inputDecorationTheme),
      child: TextFormField(
        style: LuraTextStyles.paragraph.copyWith(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: trailing,
        ),
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText,
        controller: controller,
        validator: textInputValidator,
      ),
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: const BorderSide(color: Color.fromRGBO(136, 136, 136, 0.15)),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: LuraColors.inputColor,
      focusColor: Colors.white,
      hoverColor: Colors.white,
      border: defaultBorder,
      enabledBorder: defaultBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: LuraColors.inputBorderBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(3),
        borderSide: const BorderSide(color: LuraColors.inputBorderError),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: large ? 30 : 20,
        vertical: large ? 30 : 20,
      ),
      hintStyle: LuraTextStyles.paragraph.copyWith(
        color: const Color(0xFFBBBBBB),
        fontSize: 14,
      ),
      iconColor: LuraColors.blue,
      suffixIconColor: LuraColors.blue,
    );
  }
}
