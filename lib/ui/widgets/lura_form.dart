import 'package:flutter/material.dart';
import 'package:lura_client/ui/padding.dart';

import '../colors.dart';

class LuraForm extends StatelessWidget {
  final Widget child;

  const LuraForm({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LuraColors.formBackground,
        borderRadius: BorderRadius.circular(55),
      ),
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
    );
  }
}
