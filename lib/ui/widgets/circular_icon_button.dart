import 'package:flutter/material.dart';
import 'package:mobile_printer/ui/colors.dart';

class CircularIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Icon icon;
  final EdgeInsets? padding;

  const CircularIconButton({
    Key? key,
    this.onTap,
    required this.icon,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const CircleBorder(),
            padding: padding ?? const EdgeInsets.all(20),
            primary: LuraColors.blue,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: icon,
      ),
    );
  }
}
