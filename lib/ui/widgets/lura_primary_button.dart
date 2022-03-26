import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';

class LuraPrimaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final String text;

  const LuraPrimaryButton({
    Key? key,
    this.onTap,
    this.leadingIcon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final border =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(40));
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(shape: MaterialStateProperty.all(border)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  leadingIcon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            Text(
              text,
              style: LuraTextStyles.actionButton.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
