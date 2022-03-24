import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';

import '../../core/authentication/bloc/authentication_bloc.dart';

class SideMenu extends StatelessWidget {
  final int currentPage;

  const SideMenu({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          ListView(
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
                  child: Image.asset('images/lura_logo_icon_alt.png'),
                  padding: const EdgeInsets.all(10),
                ),
              ),
              const Gap(40),
              DrawerListTile(
                title: 'Printers',
                active: currentPage == 0,
                press: () {
                  context.go('/printers');
                  _closeDrawer(context);
                },
              ),
              DrawerListTile(
                title: 'Receipts',
                active: currentPage == 1,
                press: () {
                  context.go('/receipts');
                  _closeDrawer(context);
                },
              ),
              // const Divider(),
              // DrawerListTile(
              //   title: 'Feedback',
              //   active: currentPage == 2,
              //   press: () {
              //     context.go('/feedback');
              //     _closeDrawer(context);
              //   },
              // ),
            ],
          ),
          const Spacer(),
          DrawerListTile(
            title: 'Logout',
            active: false,
            press: () {
              context.read<AuthenticationBloc>().add(LogoutRequested());
              // _closeDrawer(context);
            },
          ),
          const Gap(50),
        ],
      ),
    );
  }

  void _closeDrawer(BuildContext context) {
    if (!kIsWeb) Navigator.maybePop(context);
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
      selectedTileColor: LuraColors.inputColor,
      horizontalTitleGap: 0.0,
      title: Text(
        title,
        style:
            LuraTextStyles.baseTextStyle.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
