import 'package:flutter/material.dart';

typedef TextInputValidator = String? Function(String? input);

class LuraTextField extends StatelessWidget {

  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputValidator? textInputValidator;
  final Widget? trailing;

  const LuraTextField({
    Key? key,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.textInputValidator,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: trailing,
      ),
      keyboardType: TextInputType.text,
      obscureText: obscureText,
      controller: controller,
      validator: textInputValidator,
    );
  }
}
