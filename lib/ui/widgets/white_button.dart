import 'package:flutter/material.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';

class WhiteButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;

  const WhiteButton({
    Key? key,
    this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.black12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            primary: Colors.white,
            minimumSize: const Size(80, 30),
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: LuraTextStyles.baseTextStyle.copyWith(
              color: LuraColors.blue,
              fontWeight: FontWeight.w400,
              fontSize: 18),
        ),
      ),
    );
  }
}
