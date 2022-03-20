import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/core/printing/bloc/printer_emulation_bloc.dart';
import 'package:lura_client/screens/printers/bloc/printer_activation_screen_bloc.dart';
import 'package:lura_client/ui/widgets/loading_display.dart';
import '../widgets/app_bars.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';

class PrinterActivationScreen extends StatelessWidget {
  const PrinterActivationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenBloc = context.watch<PrinterActivationScreenBloc>();
    return Scaffold(
      appBar: luraAppBar(context),
      body: SafeArea(
        child: screenBloc.state.isLoading
            ? const Center(
                child: LoadingDisplay(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                      const _PrinterDetails(),
                      const Gap(20),
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
                              context
                                  .read<PrinterEmulationBloc>()
                                  .enterStandbyMode();
                              context.goNamed('printer-standby');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
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
    final emulationBloc = context.watch<PrinterEmulationBloc>();
    final ippDetails = emulationBloc.state.ippConnectionDetails!;
    final escPosDetails = emulationBloc.state.escPosConnectionDetails!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ipp/Airprint',
          style: LuraTextStyles.baseTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: LuraColors.blue,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Divider(
            height: 1,
            thickness: 2,
            color: LuraColors.blue.withOpacity(.5),
          ),
        ),
        _DetailItem(title: 'Printer name', value: ippDetails.name),
        _DetailItem(
            title: 'Airprint enabled',
            value: ippDetails.airprintEnabled ? 'Yes' : 'No'),
        _DetailItem(title: 'IP Address', value: ippDetails.ipAddress),
        _DetailItem(title: 'Port', value: ippDetails.port),
        Text(
          'Esc-POS',
          style: LuraTextStyles.baseTextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: LuraColors.blue,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 10),
          child: Divider(
            height: 1,
            thickness: 2,
            color: LuraColors.blue.withOpacity(.5),
          ),
        ),
        _DetailItem(title: 'IP Address', value: escPosDetails.ipAddress),
        _DetailItem(title: 'Port', value: escPosDetails.port),
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
      fontSize: 20,
    );
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Text(
        title,
        style: textStyle,
      ),
      subtitle: Text(
        value,
        style: textStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      // ],
    );
  }
}
