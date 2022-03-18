import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/core/models/receipt.dart';
import 'package:lura_client/core/viewmodels/receipts_viewmodel.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final receiptsViewmodel = context.watch<ReceiptsViewmodel>();
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
                'Receipts',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  fontSize: 40,
                  color: LuraColors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          Expanded(child: ReceiptList(receipts: [])),
        ],
      ),
    );
  }
}

class ReceiptList extends StatelessWidget {
  final List<Receipt> receipts;

  const ReceiptList({Key? key, required this.receipts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final listView = ListView.builder(
          padding: const EdgeInsets.only(top: 20),
          itemBuilder: (context, index) {
            final receipt = receipts[index];
            return _ReceiptListItem(
              receipt: receipt,
              sizingInformation: sizingInformation,
              onTap: () {},
            );
          },
          itemCount: receipts.length,
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

class _ReceiptListItem extends StatelessWidget {
  final Receipt receipt;
  final SizingInformation sizingInformation;
  final VoidCallback? onTap;

  const _ReceiptListItem({
    Key? key,
    required this.receipt,
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
                          'Receipt #${receipt.id}',
                          style: textStyle,
                        ),
                        const Gap(10),
                        Text(
                          receipt.printerName,
                          style: textStyle.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Text(
                      receipt.dateCreated,
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
