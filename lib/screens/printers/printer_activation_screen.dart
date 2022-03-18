import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_bars.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';

class PrinterActivationScreen extends StatelessWidget {
  const PrinterActivationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: luraAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(20),
              Text(
                'Printer Activated',
                style: LuraTextStyles.baseTextStyle.copyWith(
                    color: LuraColors.blue,
                    fontSize: 36,
                    fontWeight: FontWeight.w400),
              ),
              const Gap(20),
              _PrinterDetails(),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Enter standby mode',
                    style: LuraTextStyles.baseTextStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: LuraColors.blue,
                      fontSize: 20,
                    ),
                  ),
                  const Gap(20),
                  CircularIconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onTap: () {
                      context.goNamed('printer-standby');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrinterDetails extends StatelessWidget {
  const _PrinterDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _DetailItem(title: 'Printer name', value: 'LuraPrinterAndroid'),
            Gap(20),
            _DetailItem(title: 'Airprint enabled', value: 'Yes'),
            Gap(20),
            _DetailItem(title: 'IP Address', value: '10.0.0.0'),
            Gap(20),
            _DetailItem(title: 'Port', value: '9100'),
          ],
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const _DetailItem({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = LuraTextStyles.baseTextStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: LuraColors.blue,
      fontSize: 22,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        Text(
          value,
          style: textStyle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
