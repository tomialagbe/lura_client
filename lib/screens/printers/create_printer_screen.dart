import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/screens/printers/bloc/create_printer_screen_bloc.dart';
import 'package:lura_client/ui/widgets/lura_alerts/alerts.dart';
import 'package:lura_client/ui/widgets/lura_rounded_text_field.dart';
import '../widgets/app_bars.dart';
import 'package:lura_client/ui/colors.dart';
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
                  : Center(
                      child: SizedBox(
                        width: 700,
                        child: _CreatePrinterForm(
                            sizingInformation: sizingInformation),
                      ),
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

  final _formKey = GlobalKey<FormState>();

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

    final isSubmitting = createPrinterBloc.state.isSubmitting;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: widget.sizingInformation.isMobile
              ? EdgeInsets.only(
                  top: 0.1 * widget.sizingInformation.screenSize.height)
              : null,
          padding: EdgeInsets.all(widget.sizingInformation.isDesktop ? 40 : 20),
          decoration: BoxDecoration(
            color: LuraColors.formBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gap(sizingInformation.isDesktop ? 100 : 20),
                Text(
                  'Create a printer',
                  style: widget.sizingInformation.isDesktop
                      ? Theme.of(context).textTheme.headline3
                      : Theme.of(context).textTheme.headline4,
                ),
                const Gap(30),
                Text(
                  'On what platform does your POS run?',
                  style: Theme.of(context).textTheme.bodyText2,
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
                const Gap(30),
                LuraActionTextField(
                  large: widget.sizingInformation.isDesktop,
                  icon: Icons.arrow_forward,
                  hintText: 'Printer name',
                  controller: _printerNameController,
                  textInputValidator: (name) {
                    if (name == null || name.trim().isEmpty) {
                      return 'The printer name is required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  onTap: !isSubmitting
                      ? () {
                          if (_formKey.currentState?.validate() == true) {
                            final name = _printerNameController.text.trim();
                            createPrinterBloc.savePrinter(
                                name, _selectedPlatform.toLowerCase());
                          }
                        }
                      : null,
                ),
                if (createPrinterBloc.state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: LuraErrorAlert(
                      title: 'Error!',
                      message: createPrinterBloc.state.error!,
                      onClose: () {
                        createPrinterBloc.clearError();
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
        const Gap(10),
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

