import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/core/models/print_station.dart';
import 'package:lura_client/core/utils/platform_helper.dart';
import 'package:lura_client/core/viewmodels/printers_viewmodel.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:go_router/go_router.dart';

import 'create_printer_card.dart';

class PrintersScreen extends StatelessWidget {
  const PrintersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final printersViewmodel = context.watch<PrintersViewmodel>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Printers',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  fontSize: 40,
                  color: LuraColors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Expanded(child: SizedBox()),
              _AddPrinterButton(onTap: () {
                context.pushNamed('new-printer');
              }),
            ],
          ),
          // if (printersViewmodel.printers.isEmpty)
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: CreatePrinterCard(
                onTap: () {
                  context.pushNamed('new-printer');
                },
              ),
            ),
          ),
          // else
          //   Expanded(child: PrinterList(printers: printersViewmodel.printers)),
        ],
      ),
    );
  }
}

class _AddPrinterButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _AddPrinterButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularIconButton(
              icon: const Icon(Icons.add, size: 25),
              padding: const EdgeInsets.all(10),
              onTap: onTap,
            ),
            if (sizingInformation.isDesktop)
              Text(
                'Add new',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  color: LuraColors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        );
      },
    );
  }
}

class PrinterList extends StatelessWidget {
  final List<PrintStation> printers;

  const PrinterList({Key? key, required this.printers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final listView = ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemBuilder: (context, index) {
            final printer = printers[index];
            return _PrinterListItem(
              printer: printer,
              sizingInformation: sizingInformation,
              onTap: () {
                if (printer.unused) {
                  context.goNamed('printer-activate');
                } else {
                  if (PlatformHelper.isWeb) {
                    context.go('/receipts');
                  } else {
                    context.goNamed(printer.online
                        ? 'mobile-printer-actions'
                        : 'mobile-printer-actions-offline');
                  }
                }
              },
            );
          },
          itemCount: printers.length,
          shrinkWrap: true,
        );

        if (sizingInformation.isMobile) {
          return listView;
        }

        return Center(
          child: SizedBox(
            width: sizingInformation.screenSize.width * 0.6,
            height: double.infinity,
            child: Center(
              child: listView,
            ),
          ),
        );
      },
    );
  }
}

class _PrinterListItem extends StatelessWidget {
  final PrintStation printer;
  final SizingInformation sizingInformation;
  final VoidCallback? onTap;

  const _PrinterListItem({
    Key? key,
    required this.printer,
    required this.sizingInformation,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = LuraTextStyles.baseTextStyle.copyWith(
      color: LuraColors.black,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 120,
        width: double.infinity,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Material(
            clipBehavior: Clip.antiAlias,
            color: LuraColors.lightBlue,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              splashColor: LuraColors.lighterBlue,
              focusColor: LuraColors.lighterBlue,
              onTap: onTap,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          printer.name,
                          style: textStyle,
                        ),
                        const Gap(10),
                        _PlatformIcon(platform: printer.platform),
                      ],
                    ),
                    Expanded(child: Container()),
                    if (!printer.unused)
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                          color: printer.online ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                        width: 10,
                        height: 10,
                      ),
                    Text(
                      printer.unused
                          ? 'Unused'
                          : printer.online
                              ? 'Online'
                              : 'Offline',
                      style: textStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlatformIcon extends StatelessWidget {
  final String platform;

  const _PlatformIcon({Key? key, required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: LuraColors.black,
      size: 18,
    );
  }

  IconData get icon {
    switch (platform) {
      case 'windows':
        return FontAwesomeIcons.windows;
      case 'ios':
        return FontAwesomeIcons.apple;
      case 'android':
      default:
        return FontAwesomeIcons.android;
    }
  }
}
