import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lura_client/core/printers/printer.dart';
import 'package:lura_client/core/utils/platform_helper.dart';
import 'package:lura_client/screens/printers/bloc/selected_printer_bloc.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/loading_display.dart';
import 'package:lura_client/ui/widgets/lura_list_item.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:go_router/go_router.dart';

import '../../ui/widgets/buttons/lura_primary_button.dart';
import 'add_printer_button.dart';
import 'bloc/printers_screen_bloc.dart';

class PrintersScreen extends StatefulWidget {
  const PrintersScreen({Key? key}) : super(key: key);

  @override
  State<PrintersScreen> createState() => _PrintersScreenState();
}

class _PrintersScreenState extends State<PrintersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PrintersScreenBloc>().loadPrinters();
  }

  @override
  Widget build(BuildContext context) {
    final printersScreenBloc = context.watch<PrintersScreenBloc>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveBuilder(
            builder: (context, sizingInformation) {
              final isDesktop = sizingInformation.isDesktop;
              if (isDesktop) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Printers',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    const Expanded(child: SizedBox()),
                    const AddPrinterButton(),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
          if (printersScreenBloc.state.loading)
            const Expanded(child: Center(child: LoadingDisplay()))
          else if (printersScreenBloc.state.loadError != null)
            Expanded(
              child: Center(
                child: ErrorAlert(
                  error: printersScreenBloc.state.loadError!,
                  onTap: () => printersScreenBloc.loadPrinters(),
                ),
              ),
            )
          else if (printersScreenBloc.state.printers.isEmpty)
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: LuraPrimaryButton(
                  text: 'Create your first printer',
                  onTap: () {
                    context.pushNamed('new-printer');
                  },
                  leadingIcon: Icons.add,
                ),
              ),
            )
          else
            Expanded(
              child: PrinterList(printers: printersScreenBloc.state.printers),
            ),
        ],
      ),
    );
  }
}

class PrinterList extends StatefulWidget {
  final List<Printer> printers;

  const PrinterList({Key? key, required this.printers}) : super(key: key);

  @override
  State<PrinterList> createState() => _PrinterListState();
}

class _PrinterListState extends State<PrinterList> {
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
            final printer = widget.printers[index];
            return _PrinterListItem(
              printer: printer,
              sizingInformation: sizingInformation,
              onTap: () {
                context.read<SelectedPrinterBloc>().setSelectedPrinter(printer);
                if (printer.isUnused) {
                  context.goNamed('printer-activate');
                } else {
                  if (PlatformHelper.isWeb) {
                    context.go(
                        '/receipts'); // TODO: add path segment for printer id
                  } else {
                    context.goNamed(printer.isOnline
                        ? 'mobile-printer-actions'
                        : 'mobile-printer-actions-offline');
                  }
                }
              },
            );
          },
          itemCount: widget.printers.length,
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

class _PrinterListItem extends StatelessWidget {
  final Printer printer;
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LuraListItem(
        title: SelectableText(printer.name),
        trailing: _PrinterStatus(printer: printer),
        subTitle: _PlatformIcon(platform: printer.osType),
        onTap: onTap,
      ),
    );
  }
}

class _PrinterStatus extends StatelessWidget {
  final Printer printer;

  const _PrinterStatus({Key? key, required this.printer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!printer.isUnused)
          Container(
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: printer.isOnline ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
            width: 10,
            height: 10,
          ),
        Text(
          printer.isUnused
              ? 'Unused'
              : printer.isOnline
                  ? 'Online'
                  : 'Offline',
        ),
      ],
    );
  }
}

class _PlatformIcon extends StatelessWidget {
  final PrinterOsType platform;

  const _PlatformIcon({Key? key, required this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.white,
      size: 18,
    );
  }

  IconData get icon {
    switch (platform) {
      case PrinterOsType.windows:
        return FontAwesomeIcons.windows;
      case PrinterOsType.iOS:
        return FontAwesomeIcons.apple;
      case PrinterOsType.android:
      default:
        return FontAwesomeIcons.android;
    }
  }
}
