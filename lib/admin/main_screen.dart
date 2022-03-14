import 'package:flutter/material.dart';
import 'package:mobile_printer/admin/side_menu.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'printers/printers_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        return Scaffold(
          drawer: SideMenu(),
          appBar: sizingInfo.isDesktop ? null : luraAppBar(context),
          body: SafeArea(
            child: Builder(
              builder: (context) {
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
      },
    );
  }
}

PreferredSizeWidget luraAppBar(BuildContext context) {
  return AppBar(
    title: Image.asset(
      'assets/images/lura_logo_icon_alt.png',
      height: 50,
    ),
    // backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
    automaticallyImplyLeading: true,
  );
}
