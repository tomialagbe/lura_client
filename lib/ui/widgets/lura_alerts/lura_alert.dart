import 'package:flutter/material.dart';

import '../../colors.dart';

class LuraAlert extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;
  final Icon icon;
  final Color bgColor;
  final Color borderColor;
  final Color iconColor;
  final String? actionText;
  final VoidCallback? onAction;

  const LuraAlert({
    Key? key,
    required this.title,
    required this.message,
    this.onClose,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.iconColor,
    this.actionText,
    this.onAction,
  }) : super(key: key);

  @override
  State<LuraAlert> createState() => _LuraAlertState();
}

class _LuraAlertState extends State<LuraAlert> {
  bool get hasAction => widget.actionText != null;
  bool _show = true;

  @override
  Widget build(BuildContext context) {
    if (!_show) return const SizedBox.shrink();
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.bgColor,
        border: Border.all(color: widget.borderColor),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _AlertIcon(icon: widget.icon, iconColor: widget.iconColor),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.title,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: LuraColors.alertTextColor)),
                const SizedBox(height: 5),
                Text(
                  widget.message,
                  style: Theme.of(context).textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: LuraColors.alertTextColor),
                ),
                if (hasAction)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: widget.onAction,
                        child: Text(
                          widget.actionText!,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: LuraColors.alertTextColor,
                                    decoration: TextDecoration.underline,
                                  ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Expanded(child: SizedBox(), flex: 1),
          _AlertCloseButton(onTap: () {
            setState(() {
              _show = false;
            });
            widget.onClose?.call();
          }),
        ],
      ),
    );
  }
}

class _AlertCloseButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AlertCloseButton({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      padding: const EdgeInsets.only(right: 0),
      mouseCursor: SystemMouseCursors.click,
      icon: Icon(
        Icons.close,
        color: LuraColors.alertTextColor,
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  final Icon icon;
  final Color iconColor;

  const _AlertIcon({Key? key, required this.icon, required this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor,
      ),
      width: 50,
      height: 50,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconTheme(
                data: IconThemeData(color: iconColor, size: 20),
                child: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
