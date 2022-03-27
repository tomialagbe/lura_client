import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';
import 'circular_icon_button.dart';

typedef TextInputValidator = String? Function(String? input);

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
    // final inputTheme = Theme.of(context).inputDecorationTheme;
    final decoration = !large ? defaultInputDecoration : largeInputDecoration;
    return TextFormField(
      style: LuraTextStyles.paragraph,
      // decoration: InputDecoration(
      //   hintText: hintText,
      //   suffixIcon: trailing,
      // ),
      decoration: decoration,
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      controller: controller,
      validator: textInputValidator,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: LuraColors.inputBorderBlue),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
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
    return LuraTextField(
      hintText: hintText,
      trailing: LuraCircularIconButton(
        icon: icon,
        onTap: onTap,
        size: large ? 50 : null,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      textInputValidator: textInputValidator,
      large: large,
    );
  }
}
