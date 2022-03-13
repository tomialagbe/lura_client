import 'package:flutter/material.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:go_router/go_router.dart';

class PrintersScreen extends StatelessWidget {
  const PrintersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Printers',
            style: LuraTextStyles.baseTextStyle.copyWith(
              fontSize: 40,
              color: LuraColors.blue,
              fontWeight: FontWeight.w400,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: _CreatePrinterCard(
                onTap: () {
                  context.push('/create_printer');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePrinterCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _CreatePrinterCard({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _CardContent(
                onTap: onTap,
              ),
            ),
            Positioned(
              top: 5,
              right: -5,
              child: _CardPlusIcon(),
            ),
          ],
        );
      },
    );
  }
}

class _CardContent extends StatelessWidget {
  final VoidCallback? onTap;

  const _CardContent({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black12),
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          highlightColor: Colors.white70,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Create your first printer',
              style: LuraTextStyles.baseTextStyle.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardPlusIcon extends StatelessWidget {
  const _CardPlusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
            primary: LuraColors.blue,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
