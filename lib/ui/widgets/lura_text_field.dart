import 'package:flutter/material.dart';

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
      style: LuraTextStyles.paragraph,
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

class LuraActionTextField extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputValidator? textInputValidator;

  const LuraActionTextField({
    Key? key,
    required this.icon,
    this.onTap,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.textInputValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LuraTextField(
      hintText: hintText,
      trailing: LuraCircularIconButton(
        icon: icon,
        onTap: onTap,
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      controller: controller,
      textInputValidator: textInputValidator,
    );
  }
}
