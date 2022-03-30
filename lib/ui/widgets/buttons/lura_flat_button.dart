import 'package:flutter/material.dart';

import '../../typography.dart';

class LuraFlatButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const LuraFlatButton({
    Key? key,
    this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5));
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(shape: MaterialStateProperty.all(border)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            text,
            style: LuraTextStyles.paragraph.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
