import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/core/print_jobs/print_job.dart';
import 'package:lura_client/screens/receipts/bloc/receipts_screen_bloc.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/loading_display.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/link_opener.dart' as link_opener;

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenBloc = context.watch<ReceiptsScreenBloc>();
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
          if (screenBloc.state.loading)
            const Expanded(child: Center(child: LoadingDisplay()))
          else if (screenBloc.state.loadError != null)
            Expanded(
              child: Center(
                child: ErrorAlert(
                  error: screenBloc.state.loadError!,
                  onTap: () => screenBloc.loadReceipts(),
                ),
              ),
            )
          else
            Expanded(child: ReceiptList(receipts: screenBloc.state.receipts)),
        ],
      ),
    );
  }
}

class ReceiptList extends StatelessWidget {
  final List<PrintJob> receipts;

  const ReceiptList({Key? key, required this.receipts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final listView = ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 20),
          itemBuilder: (context, index) {
            final receipt = receipts[index];
            return _ReceiptListItem(
              receipt: receipt,
              sizingInformation: sizingInformation,
              onTap: () {
                link_opener.openLinkInNewWindow(receipt.downloadUrl);
              },
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
  final PrintJob receipt;
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
                      receipt.createdAt,
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
