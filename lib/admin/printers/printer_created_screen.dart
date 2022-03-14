import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:mobile_printer/admin/app_bars.dart';
import 'package:mobile_printer/core/utils/platform_helper.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PrinterCreatedScreen extends StatelessWidget {
  const PrinterCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        return Scaffold(
          appBar: luraAppBar(context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(sizingInformation.isDesktop ? 100 : 20),
                  Text(
                    'Printer created',
                    style: LuraTextStyles.baseTextStyle.copyWith(
                        color: LuraColors.blue,
                        fontSize: 36,
                        fontWeight: FontWeight.w400),
                  ),
                  if (!PlatformHelper.isWeb && PlatformHelper.isMobile)
                    ..._mobileWidgets(),
                  if (PlatformHelper.isWeb) ..._webWidgets()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _mobileWidgets() {
    return [
      Expanded(child: Container()),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset('assets/images/check_mark.svg')],
      ),
      const Gap(30),
      Text('Your printer has been created successfully',
          style: LuraTextStyles.baseTextStyle
              .copyWith(color: LuraColors.blue, fontWeight: FontWeight.w400)),
      Expanded(child: Container()),
      SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ShowPrintersButton(onTap: () {}),
            const Gap(10),
            _ActivateButton(onTap: () {}),
          ],
        ),
      ),
    ];
  }

  List<Widget> _webWidgets() {
    return [];
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

class _ShowPrintersButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ShowPrintersButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(color: Colors.black12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            primary: Colors.white,
            minimumSize: const Size(80, 30),
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          'Show all printers',
          style: LuraTextStyles.baseTextStyle.copyWith(
              color: LuraColors.blue,
              fontWeight: FontWeight.w400,
              fontSize: 18),
        ),
      ),
    );
  }
}
