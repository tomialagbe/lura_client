import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

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
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      final isDesktop = sizingInfo.isDesktop;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          style: ButtonStyle(shape: MaterialStateProperty.all(border)),
          child: Padding(
            padding: isDesktop
                ? const EdgeInsets.all(20)
                : const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
    });
  }
}
