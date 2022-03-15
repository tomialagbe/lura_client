import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/admin/app_bars.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'platform_selector.dart';

class CreatePrinterScreen extends StatelessWidget {
  const CreatePrinterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return Scaffold(
          appBar: luraAppBar(context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: sizingInformation.isMobile
                  ? SingleChildScrollView(
                      child: buildForm(context, sizingInformation))
                  : buildForm(context, sizingInformation),
            ),
          ),
        );
      },
    );
  }

  Widget buildForm(BuildContext context, SizingInformation sizingInformation) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(sizingInformation.isDesktop ? 100 : 20),
        Text(
          'Create a printer',
          style: LuraTextStyles.baseTextStyle.copyWith(
              color: LuraColors.blue,
              fontSize: 36,
              fontWeight: FontWeight.w400),
        ),
        const Gap(70),
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                style: const TextStyle(fontSize: 18, color: LuraColors.blue),
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Printer name',
                  hintStyle: TextStyle(color: LuraColors.blue),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const Gap(30),
              Text(
                'On what platform does your POS run?',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  color: LuraColors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(20),
              PlatformSelector(
                onChange: (selectedPlatform) {},
              ),
              const Gap(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _SubmitButton(
                    onTap: () {
                      context.goNamed('new-printer-created');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _SubmitButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            primary: LuraColors.blue,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: const Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}
