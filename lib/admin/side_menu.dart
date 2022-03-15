import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/ui/typography.dart';

class SideMenu extends StatelessWidget {
  final int currentPage;

  const SideMenu({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Gap(50),
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(
                color: Colors.transparent,
                thickness: 0,
              ),
            ),
            child: DrawerHeader(
              child: Image.asset("assets/images/lura_logo_icon_alt.png"),
              padding: const EdgeInsets.all(10),
            ),
          ),
          const Gap(40),
          DrawerListTile(
            title: "Printers",
            active: currentPage == 0,
            press: () {
              context.go('/printers');
            },
          ),
          DrawerListTile(
            title: "Receipts",
            active: currentPage == 1,
            press: () {
              context.go('/receipts');
            },
          ),
          const Divider(),
          DrawerListTile(
            title: "Feedback",
            active: currentPage == 2,
            press: () {
              context.go('/feedback');
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    this.active = false,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      selected: active,
      selectedColor: Colors.red,
      horizontalTitleGap: 0.0,
      title: Text(
        title,
        style:
            LuraTextStyles.baseTextStyle.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
