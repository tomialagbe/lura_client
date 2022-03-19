import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/screens/printers/bloc/create_printer_screen_bloc.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import '../widgets/app_bars.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

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
                      child: _CreatePrinterForm(
                          sizingInformation: sizingInformation))
                  : Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: _CreatePrinterForm(
                          sizingInformation: sizingInformation),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _CreatePrinterForm extends StatefulWidget {
  final SizingInformation sizingInformation;

  const _CreatePrinterForm({Key? key, required this.sizingInformation})
      : super(key: key);

  @override
  _CreatePrinterFormState createState() => _CreatePrinterFormState();
}

class _CreatePrinterFormState extends State<_CreatePrinterForm> {
  late SizingInformation sizingInformation;
  final _printerNameController = TextEditingController();
  final _formCompleteStream = BehaviorSubject.seeded(false);

  static const _initialPlatform = 'windows';
  String _selectedPlatform = _initialPlatform;

  @override
  void initState() {
    super.initState();
    sizingInformation = widget.sizingInformation;
    _printerNameController.addListener(() {
      _formCompleteStream
          .add(_printerNameController.text.trim().isEmpty ? false : true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final createPrinterBloc = context.watch<CreatePrinterScreenBloc>();
    if (createPrinterBloc.state.completed) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        context.goNamed('new-printer-created');
      });
    }

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
                controller: _printerNameController,
                style: const TextStyle(fontSize: 18, color: LuraColors.blue),
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Printer name',
                  hintStyle: TextStyle(
                    color: LuraColors.blue,
                    fontSize: 20,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                ),
                validator: (name) {
                  if (name == null || name.trim().isEmpty) {
                    return 'The printer name is required';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
              const Gap(30),
              Text(
                'On what platform does your POS run?',
                style: LuraTextStyles.baseTextStyle.copyWith(
                  color: LuraColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Gap(20),
              PlatformSelector(
                initialValue: 'windows',
                onChange: (selectedPlatform) {
                  setState(() {
                    _selectedPlatform = selectedPlatform.toLowerCase();
                  });
                },
              ),
              if (createPrinterBloc.state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ErrorAlert(
                    error: createPrinterBloc.state.error!,
                    showRetry: false,
                  ),
                ),
              const Gap(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<bool>(
                    stream: _formCompleteStream,
                    builder: (context, snapshot) {
                      final formComplete = snapshot.data ?? false;
                      final isSubmitting = createPrinterBloc.state.isSubmitting;
                      return _SubmitButton(
                        onTap: formComplete && !isSubmitting
                            ? () {
                                final name = _printerNameController.text.trim();
                                createPrinterBloc.savePrinter(
                                    name, _selectedPlatform.toLowerCase());
                                // context.goNamed('new-printer-created');
                              }
                            : null,
                      );
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
