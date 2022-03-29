import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';

import '../../colors.dart';

class LuraActionButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String text;
  final double? width;
  final IconData? actionIcon;
  final Color? bottomColor;
  final Color? topColor;
  final Color? defaultTextColor;
  final Color? highlightTextColor;

  const LuraActionButton({
    Key? key,
    required this.text,
    this.onTap,
    this.width,
    this.actionIcon = Icons.arrow_forward,
    this.bottomColor = Colors.black,
    this.topColor = Colors.white,
    this.defaultTextColor = Colors.white,
    this.highlightTextColor = Colors.black,
  }) : super(key: key);

  @override
  _LuraActionButtonState createState() => _LuraActionButtonState();
}

class _LuraActionButtonState extends State<LuraActionButton>
    with TickerProviderStateMixin {
  static const double _defaultWidth = 300;

  bool _expand = false;
  late double _width;

  late final AnimationController _textColorAnimationController;
  late final Animation<Color?> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _width = (widget.width ?? _defaultWidth) + 62;

    _textColorAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _textColorAnimation = ColorTween(
            begin: widget.defaultTextColor, end: widget.highlightTextColor)
        .animate(_textColorAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 40;
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onHover: (isHovering) {
          setState(() {
            _expand = isHovering;
          });
          if (_expand) {
            _textColorAnimationController.forward();
          } else {
            _textColorAnimationController.reverse();
          }
        },
        onTap: () {},
        child: Container(
          width: _width,
          height: 76,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: widget.bottomColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: _expand ? _width : 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: widget.topColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  alignment: Alignment.center,
                  width: 62,
                  height: 62,
                  child: Icon(widget.actionIcon, color: LuraColors.black),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: AnimatedBuilder(
                  animation: _textColorAnimation,
                  builder: (ctx, child) {
                    return Text(
                      widget.text,
                      style: LuraTextStyles.actionButton
                          .copyWith(color: _textColorAnimation.value),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textColorAnimationController.dispose();
    super.dispose();
  }
}
