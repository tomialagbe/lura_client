import 'package:flutter/material.dart';
import 'package:lura_client/ui/colors.dart';

class LuraCircularIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final EdgeInsets? padding;
  final double? size;

  const LuraCircularIconButton({
    Key? key,
    this.onTap,
    required this.icon,
    this.padding,
    this.size,
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
