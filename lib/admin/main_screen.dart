import 'package:flutter/material.dart';
import 'package:mobile_printer/admin/side_menu.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'printers_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, sizingInfo) {
            if (sizingInfo.isDesktop) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SideMenu(), flex: 1),
                  Expanded(
                    child: PrintersScreen(),
                    flex: 4,
                  ),
                ],
              );
            }

            return PrintersScreen();
          },
        ),
      ),
    );
  }
}
