import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mobile_printer/ui/typography.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

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
            press: () {},
          ),
          DrawerListTile(
            title: "Receipts",
            press: () {},
          ),
          const Divider(),
          DrawerListTile(
            title: "Feedback",
            press: () {},
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
  }) : super(key: key);

  final String title;

  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      title: Text(
        title,
        style:
            LuraTextStyles.baseTextStyle.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
