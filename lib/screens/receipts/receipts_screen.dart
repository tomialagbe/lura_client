import 'package:flutter/material.dart';
import 'package:lura_client/core/print_jobs/print_job.dart';
import 'package:lura_client/screens/receipts/bloc/receipts_screen_bloc.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/loading_display.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../ui/widgets/lura_list_item.dart';
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
          ResponsiveBuilder(builder: (context, sizingInfo) {
            if (sizingInfo.isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Receipts',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const Expanded(child: SizedBox()),
                ],
              );
            }

            return const SizedBox();
          }),
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

class ReceiptList extends StatefulWidget {
  final List<PrintJob> receipts;

  const ReceiptList({Key? key, required this.receipts}) : super(key: key);

  @override
  State<ReceiptList> createState() => _ReceiptListState();
}

class _ReceiptListState extends State<ReceiptList> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final listView = ListView.builder(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 20),
          itemBuilder: (context, index) {
            final receipt = widget.receipts[index];
            return _ReceiptListItem(
              receipt: receipt,
              sizingInformation: sizingInformation,
              onTap: () {
                link_opener.openLinkInNewWindow(context, receipt.downloadUrl);
              },
            );
          },
          itemCount: widget.receipts.length,
          shrinkWrap: true,
        );

        if (sizingInformation.isMobile) {
          return listView;
        }

        return Center(
          child: SizedBox(
            width: 700,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LuraListItem(
        title: SelectableText('Receipt #${receipt.id}'),
        trailing: sizingInformation.isDesktop
            ? SelectableText(receipt.createdAt)
            : null,
        subTitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(receipt.printerName),
            if (sizingInformation.isMobile) SelectableText(receipt.createdAt),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
