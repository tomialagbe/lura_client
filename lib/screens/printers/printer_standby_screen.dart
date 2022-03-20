import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrinterStandbyScreen extends StatelessWidget {
  const PrinterStandbyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    child: const Text(
                      'Exit',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Text(
                'Hi! Your receipt will show up here',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  color: LuraColors.blue,
                  fontSize: 20,
                ),
              ),
              const Gap(20),
              const _AnimatedIcon(),
              const Gap(20),
              // Text(
              //   'Hi! Here\'s your receipt',
              //   style: LuraTextStyles.baseTextStyle.copyWith(
              //     fontWeight: FontWeight.w400,
              //     color: LuraColors.blue,
              //     fontSize: 20,
              //   ),
              // ),
              // const Gap(20),
              // _AnimatedIcon(),
              // const Gap(20),
              // SizedBox(
              //   child: QrImage(
              //     data: 'example.com',
              //     foregroundColor: LuraColors.blue,
              //   ),
              //   width: 200,
              //   height: 200,
              // ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedIcon extends StatefulWidget {
  const _AnimatedIcon({Key? key}) : super(key: key);

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: -1).animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _BouncingArrow(animation: _animation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class _BouncingArrow extends AnimatedWidget {
  const _BouncingArrow({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        children: [
          Align(
            alignment: Alignment(0, animation.value),
            child: const Icon(
              FontAwesomeIcons.arrowDown,
              color: LuraColors.blue,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
