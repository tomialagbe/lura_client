import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('images/under_construction.svg'),
          const Gap(20),
          Text(
            'Coming soon',
            style: LuraTextStyles.baseTextStyle.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              color: LuraColors.blue,
            ),
          ),
          const Gap(10),
          const Text('We are currently working on this.'),
        ],
      ),
    );
  }
}
