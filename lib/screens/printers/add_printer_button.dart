import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../ui/widgets/circular_icon_button.dart';

class AddPrinterButton extends StatelessWidget {
  final VoidCallback? onTap;

  const AddPrinterButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LuraCircularIconButton(
              icon: Icons.add,
              size: 25,
              padding: const EdgeInsets.all(10),
              onTap: () {
                context.pushNamed('new-printer');
              },
            ),
            if (sizingInformation.isDesktop)
              Text(
                'Add new',
                style: Theme.of(context).textTheme.bodyText2,
              ),
          ],
        );
      },
    );
  }
}
