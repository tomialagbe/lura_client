import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/business/business_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'receipts/bloc/receipts_screen_bloc.dart';
import 'widgets/app_bars.dart';
import 'feedback_screen.dart';
import 'printers/printers_screen.dart';
import 'receipts/receipts_screen.dart';
import 'widgets/side_menu.dart';

class MainScreen extends StatefulWidget {
  final String page;

  const MainScreen({Key? key, required this.page}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const _pageIndices = {
    'printers': 0,
    'receipts': 1,
    'feedback': 2,
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = _pageIndices[widget.page] ?? 0;
    });
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedIndex != (_pageIndices[widget.page] ?? 0)) {
      setState(() {
        _selectedIndex = _pageIndices[widget.page] ?? 0;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _selectedIndex = _pageIndices[widget.page] ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        return Scaffold(
          drawer: SideMenu(currentPage: _selectedIndex),
          appBar: sizingInfo.isDesktop ? null : luraAppBar(context),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (sizingInfo.isDesktop) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: SideMenu(currentPage: _selectedIndex),
                          flex: 1),
                      Expanded(
                        child: _ContentSlot(selectedIndex: _selectedIndex),
                        flex: 4,
                      ),
                    ],
                  );
                }

                return _ContentSlot(selectedIndex: _selectedIndex);
              },
            ),
          ),
        );
      },
    );
  }
}

class _ContentSlot extends StatelessWidget {
  final int selectedIndex;

  const _ContentSlot({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final business = context.read<BusinessBloc>().state!;
    return IndexedStack(
      index: selectedIndex,
      children: [
        const PrintersScreen(),
        BlocProvider(
          create: (ctx) => ReceiptsScreenBloc(businessId: business.id),
          child: const ReceiptsScreen(),
        ),
        const FeedbackScreen(),
      ],
    );
  }
}
