import 'package:flutter/material.dart';
import 'package:lura_client/core/print_jobs/print_job.dart';
import 'package:lura_client/screens/receipts/bloc/receipts_screen_bloc.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/loading_display.dart';
import 'package:lura_client/ui/widgets/refresh_widget.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../core/utils/platform_helper.dart';
import '../../ui/widgets/lura_list_item.dart';
import '../../utils/link_opener.dart' as link_opener;

class ReceiptsScreen extends StatelessWidget {
  const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ResponsiveBuilder(builder: (context, sizingInformation) {
        final isMobile = sizingInformation.isMobile;
        if (isMobile) {
          return _MobileReceiptsScreen(sizingInformation: sizingInformation);
        }
        return _DesktopReceiptsScreen(sizingInformation: sizingInformation);
      }),
    );
    /*final screenBloc = context.watch<ReceiptsScreenBloc>();
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
                  SelectableText(
                    'Receipts',
                    style: Theme.of(context).textTheme.headline3,
                    toolbarOptions: const ToolbarOptions(copy: true),
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
    );*/
  }
}

class _MobileReceiptsScreen extends StatelessWidget {
  final SizingInformation sizingInformation;

  const _MobileReceiptsScreen({Key? key, required this.sizingInformation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenBloc = context.watch<ReceiptsScreenBloc>();
    if (screenBloc.state.loading) {
      return const Center(child: LoadingDisplay());
    } else if (screenBloc.state.loadError != null) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: ErrorAlert(
          error: screenBloc.state.loadError!,
          onTap: () => screenBloc.loadReceipts(),
        ),
      );
    }

    return ReceiptList(
      receipts: screenBloc.state.receipts,
      onRefresh: () async {
        return screenBloc.loadReceipts();
      },
      isMobile: true,
    );
  }
}

class _DesktopReceiptsScreen extends StatelessWidget {
  final SizingInformation sizingInformation;

  const _DesktopReceiptsScreen({Key? key, required this.sizingInformation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenBloc = context.watch<ReceiptsScreenBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              'Receipts',
              style: Theme.of(context).textTheme.headline3,
              toolbarOptions: const ToolbarOptions(copy: true),
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
          Expanded(
            child: ReceiptList(
              receipts: screenBloc.state.receipts,
              isMobile: false,
              onRefresh: () async {
                return screenBloc.loadReceipts();
              },
            ),
          ),
      ],
    );
  }
}

class ReceiptList extends StatelessWidget {
  final List<PrintJob> receipts;
  final Future Function() onRefresh;
  final bool isMobile;

  const ReceiptList({
    Key? key,
    required this.receipts,
    required this.onRefresh,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    final isIos = !PlatformHelper.isWeb && PlatformHelper.isIOS;

    Widget listView;
    if (isIos) {
      listView = SliverList(
        delegate: SliverChildBuilderDelegate(
          _itemBuilder,
          childCount: receipts.length,
        ),
      );
    } else {
      listView = ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20),
        itemBuilder: _itemBuilder,
        itemCount: receipts.length,
      );
    }

    final statefulList = StatefulBuilder(
      builder: (ctx, setState) {
        return listView;
      },
    );

    if (isMobile) {
      return RefreshWidget(
        onRefresh: onRefresh,
        child: statefulList,
      );
    }

    return Center(
      child: SizedBox(
        width: 700,
        height: double.infinity,
        child: Center(
          child: statefulList,
        ),
      ),
    );
  }

  Widget _itemBuilder(context, index) {
    final receipt = receipts[index];
    return _ReceiptListItem(
      receipt: receipt,
      isMobile: isMobile,
      onTap: () {
        link_opener.openLinkInNewWindow(context, receipt.downloadUrl);
      },
    );
  }
}

class _ReceiptListItem extends StatelessWidget {
  final PrintJob receipt;
  final VoidCallback? onTap;
  final bool isMobile;

  const _ReceiptListItem({
    Key? key,
    required this.receipt,
    this.onTap,
    required this.isMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDesktop = isMobile == false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LuraListItem(
        title: SelectableText('Receipt #${receipt.id}'),
        trailing: isDesktop ? SelectableText(receipt.createdAt) : null,
        subTitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(receipt.printerName),
            if (isMobile) SelectableText(receipt.createdAt),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
