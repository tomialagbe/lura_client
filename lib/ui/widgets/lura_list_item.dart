import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';

import '../colors.dart';

class LuraListItem extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget title;
  final Widget? subTitle;
  final Widget? trailing;

  const LuraListItem({
    Key? key,
    required this.title,
    this.onTap,
    this.subTitle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LuraColors.blue,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ListItemTitles(
                title: title,
                subTitle: subTitle,
              ),
              const Expanded(child: SizedBox()),
              if (trailing != null) _ListItemTrailing(trailing: trailing!),
            ],
          ),
        ),
      ),
    );
  }
}

class _ListItemTitles extends StatelessWidget {
  final Widget title;
  final Widget? subTitle;

  const _ListItemTitles({
    Key? key,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: LuraTextStyles.paragraph.copyWith(color: Colors.white),
          child: title,
        ),
        if (subTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconTheme(
              data: const IconThemeData(color: Colors.white, size: 20),
              child: DefaultTextStyle(
                style: LuraTextStyles.paragraphSmall
                    .copyWith(color: Colors.white70),
                child: subTitle!,
              ),
            ),
          ),
      ],
    );
  }
}

class _ListItemTrailing extends StatelessWidget {
  final Widget trailing;

  const _ListItemTrailing({Key? key, required this.trailing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: LuraTextStyles.paragraphSmallest.copyWith(color: Colors.white),
      child: IconTheme(
        data: const IconThemeData(color: Colors.white, size: 20),
        child: trailing,
      ),
    );
  }
}
