import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/typography.dart';
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
                'Hi! Here\'s your receipt',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  color: LuraColors.blue,
                  fontSize: 20,
                ),
              ),
              const Gap(20),
              _AnimatedIcon(),
              const Gap(20),
              SizedBox(
                child: QrImage(
                  data: 'example.com',
                  foregroundColor: LuraColors.blue,
                ),
                width: 200,
                height: 200,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedIcon extends StatelessWidget {
  const _AnimatedIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Icon(
      FontAwesomeIcons.arrowDown,
      color: LuraColors.blue,
      size: 30,
    );
  }
}
