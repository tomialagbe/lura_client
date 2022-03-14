import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/theme.dart';
import 'package:mobile_printer/ui/typography.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'platform_selector.dart';

class CreatePrinterScreen extends StatelessWidget {
  const CreatePrinterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuraColors.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Text(
                'Create a printer',
                style: LuraTextStyles.baseTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w400),
              ),
              Expanded(
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: false,
                          hintText: 'Printer name',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                          border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                      const Gap(30),
                      Text(
                        'On what platform does your POS run?',
                        style: LuraTextStyles.baseTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Gap(20),
                      PlatformSelector(),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _SubmitButton(
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            primary: Colors.white,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: const Icon(
          Icons.arrow_forward,
          color: LuraColors.blue,
        ),
      ),
    );
  }
}
