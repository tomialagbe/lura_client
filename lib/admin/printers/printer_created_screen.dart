import 'package:flutter/material.dart';
import 'package:mobile_printer/admin/app_bars.dart';
import 'package:mobile_printer/ui/colors.dart';

class PrinterCreatedScreen extends StatelessWidget {
  const PrinterCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuraColors.blue,
      appBar: luraTransparentAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
