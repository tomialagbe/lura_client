import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_bars.dart';
import '../../core/utils/platform_helper.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/white_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PrinterCreatedScreen extends StatelessWidget {
  final bool forActivation;
  final bool forCreationComplete;
  final bool showReceiptButton;
  final bool hideActivationButton;

  const PrinterCreatedScreen({
    Key? key,
    this.forCreationComplete = true,
    this.forActivation = false,
    this.showReceiptButton = false,
    this.hideActivationButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return Scaffold(
          appBar: luraAppBar(context),
          body: SafeArea(
            child: PlatformHelper.isWeb
                ? SingleChildScrollView(
                    child: _ScreenContent(
                      sizingInformation: sizingInformation,
                      forCreationComplete: forCreationComplete,
                      forActivation: forActivation,
                      showReceiptButton: showReceiptButton,
                      hideActivationButton: hideActivationButton,
                    ),
                  )
                : _ScreenContent(
                    sizingInformation: sizingInformation,
                    forCreationComplete: forCreationComplete,
                    forActivation: forActivation,
                    showReceiptButton: showReceiptButton,
                    hideActivationButton: hideActivationButton,
                  ),
          ),
        );
      },
    );
  }
}

class _ScreenContent extends StatelessWidget {
  final textStyle = LuraTextStyles.baseTextStyle
      .copyWith(color: LuraColors.blue, fontWeight: FontWeight.w400);

  final bool forCreationComplete;
  final bool forActivation;
  final bool showReceiptButton;
  final bool hideActivationButton;
  final SizingInformation sizingInformation;

  _ScreenContent({
    Key? key,
    required this.sizingInformation,
    required this.forCreationComplete,
    required this.forActivation,
    required this.showReceiptButton,
    required this.hideActivationButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(sizingInformation.isDesktop ? 100 : 20),
            Text(
              forCreationComplete
                  ? 'Printer created'
                  : forActivation
                      ? 'Activate printer'
                      : 'Printer actions',
              style: LuraTextStyles.baseTextStyle.copyWith(
                  color: LuraColors.blue,
                  fontSize: 36,
                  fontWeight: FontWeight.w400),
            ),
            if (!PlatformHelper.isWeb && PlatformHelper.isMobile)
              ..._mobileWidgets(context),
            if (PlatformHelper.isWeb) _webWidgets(context, sizingInformation)
          ],
        ),
      ),
    );
  }

  List<Widget> _mobileWidgets(BuildContext context) {
    return [
      Expanded(child: Container()),
      if (forCreationComplete) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [SvgPicture.asset('assets/images/check_mark.svg')],
        ),
        const Gap(30),
        Text('Your printer has been created successfully', style: textStyle),
      ],
      Expanded(child: Container()),
      SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showReceiptButton) ...[
              WhiteButton(
                text: 'Show receipts',
                onTap: () {
                  context.go('/receipts');
                },
              ),
              const Gap(10),
            ],
            WhiteButton(
              text: 'Show all printers',
              onTap: () {
                context.pop();
              },
            ),
            const Gap(10),
            if (!hideActivationButton)
              _ActivateButton(onTap: () {
                context.goNamed('printer-activation');
              }),
          ],
        ),
      ),
    ];
  }

  Widget _webWidgets(
      BuildContext context, SizingInformation sizingInformation) {
    return Container(
      constraints: sizingInformation.isDesktop
          ? const BoxConstraints(maxWidth: 800)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(40),
          Text(
            'How to setup your pinter',
            style: textStyle.copyWith(fontSize: 24),
          ),
          const Gap(20),
          Text(
            '1. Download our app',
            style: textStyle,
          ),
          const Gap(10),
          Row(
            children: const [
              _DownloadAppButton(
                label: 'Android',
                icon: FontAwesomeIcons.android,
              ),
              Gap(20),
              _DownloadAppButton(
                label: 'iOS',
                icon: FontAwesomeIcons.apple,
              ),
            ],
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '2. Sign in',
                style: textStyle,
              ),
              const Expanded(child: SizedBox()),
              Image.asset(
                'images/screenshot_signin.png',
                fit: BoxFit.cover,
                height: 300,
                // width: 100,
              ),
            ],
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '3. Select the printer you just created',
                style: textStyle,
              ),
              const Expanded(child: SizedBox()),
              Image.asset(
                'images/screenshot_select_printer.png',
                fit: BoxFit.cover,
                height: 300,
                // width: 100,
              ),
            ],
          ),
          const Gap(20),
          Text(
            '4. Activate!',
            style: textStyle,
          ),
          const Gap(40),
          ElevatedButton(
            onPressed: () {
              context.go('/printers');
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Back to printers',
                style: LuraTextStyles.baseTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
            ),
          ),
          const Gap(100),
        ],
      ),
    );
  }
}

class _ActivateButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ActivateButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        'Activate printer on this device',
        style: LuraTextStyles.baseTextStyle.copyWith(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
      ),
    );
  }
}

class _DownloadAppButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _DownloadAppButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: 130,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const Gap(10),
              Text(
                label,
                style: LuraTextStyles.baseTextStyle.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
