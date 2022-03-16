import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/admin/app_bars.dart';
import 'package:lura_client/core/viewmodels/printers_viewmodel.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

import 'platform_selector.dart';

class CreatePrinterScreen extends StatefulWidget {
  const CreatePrinterScreen({Key? key}) : super(key: key);

  @override
  State<CreatePrinterScreen> createState() => _CreatePrinterScreenState();
}

class _CreatePrinterScreenState extends State<CreatePrinterScreen> {
  static const _initialPlatform = 'windows';
  String _selectedPlatform = _initialPlatform;

  final _printerNameController = TextEditingController();
  final _formCompleteStream = BehaviorSubject.seeded(false);

  @override
  void initState() {
    super.initState();

    _printerNameController.addListener(() {
      _formCompleteStream
          .add(_printerNameController.text.trim().isEmpty ? false : true);
    });
  }

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
                      child: buildForm(context, sizingInformation))
                  : Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: buildForm(context, sizingInformation),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget buildForm(BuildContext context, SizingInformation sizingInformation) {
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
                    _selectedPlatform = selectedPlatform;
                  });
                },
              ),
              const Gap(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<bool>(
                    stream: _formCompleteStream,
                    builder: (context, snapshot) {
                      return _SubmitButton(
                        onTap: (snapshot.data ?? false)
                            ? () {
                                context.read<PrintersViewmodel>().addPrinter(
                                    _printerNameController.text.trim(),
                                    _selectedPlatform);
                                context.goNamed('new-printer-created');
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
