import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';
import 'circular_icon_button.dart';
import 'text_input_validator.dart';

class LuraRoundedTextField extends StatelessWidget {
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputValidator? textInputValidator;
  final Widget? trailing;
  final bool large;

  const LuraRoundedTextField({
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
    final decoration = !large ? defaultInputDecoration : largeInputDecoration;
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: _inputDecorationTheme,
      ),
      child: TextFormField(
        style: LuraTextStyles.paragraph,
        decoration: decoration,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText,
        controller: controller,
        validator: textInputValidator,
      ),
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
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

  InputDecoration get defaultInputDecoration {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: trailing,
    );
  }

  InputDecoration get largeInputDecoration {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: trailing,
      contentPadding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: LuraColors.inputBorderBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40),
        borderSide: const BorderSide(color: LuraColors.inputBorderError),
      ),
    );
  }
}

class LuraActionTextField extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputValidator? textInputValidator;
  final bool large;

  const LuraActionTextField({
    Key? key,
    required this.icon,
    this.onTap,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.textInputValidator,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LuraRoundedTextField(
      hintText: hintText,
      trailing: LuraCircularIconButton(
        icon: icon,
        onTap: onTap,
        size: large ? 40 : null,
        padding: !large ? const EdgeInsets.all(15) : null,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      textInputValidator: textInputValidator,
      large: large,
    );
  }
}
