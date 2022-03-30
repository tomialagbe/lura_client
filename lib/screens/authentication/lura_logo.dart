import 'package:flutter/material.dart';

class LuraLogo extends StatelessWidget {
  const LuraLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/lura_logo.png',
      fit: BoxFit.cover,
      width: 100,
      height: 100,
    );
  }
}
