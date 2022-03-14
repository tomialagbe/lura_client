import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/theme.dart';
import 'package:mobile_printer/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PlatformSelector extends StatefulWidget {
  final Function(String)? onChange;

  const PlatformSelector({Key? key, this.onChange}) : super(key: key);

  @override
  State<PlatformSelector> createState() => _PlatformSelectorState();
}

class _PlatformSelectorState extends State<PlatformSelector> {
  String _currentValue = 'Windows';

  @override
  void initState() {
    super.initState();
    widget.onChange?.call(_currentValue);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (BuildContext context, SizingInformation sizingInformation) {
        final isDesktop = sizingInformation.isDesktop;

        final children = [
          _PlatformSelectorButton(
            icon: FontAwesomeIcons.apple,
            label: 'iOS',
            onTap: () {
              setState(() {
                _currentValue = 'iOS';
              });
            },
            selected: _currentValue == 'iOS',
            isDesktop: isDesktop,
          ),
          const Gap(10),
          _PlatformSelectorButton(
            icon: FontAwesomeIcons.android,
            label: 'Android',
            onTap: () {
              setState(() {
                _currentValue = 'Android';
              });
            },
            selected: _currentValue == 'Android',
            isDesktop: isDesktop,
          ),
          const Gap(10),
          _PlatformSelectorButton(
            icon: FontAwesomeIcons.windows,
            label: 'Windows',
            onTap: () {
              setState(() {
                _currentValue = 'Windows';
              });
            },
            selected: _currentValue == 'Windows',
            isDesktop: isDesktop,
          ),
        ];

        return Theme(
          data: Theme.of(context).copyWith(
              elevatedButtonTheme: LuraTheme.invertedElevatedButtonTheme),
          child: sizingInformation.isMobile
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              )
              : Row(children: children),
        );
      },
    );
  }
}

class _PlatformSelectorButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;
  final bool isDesktop;

  const _PlatformSelectorButton({
    Key? key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.isDesktop = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: LuraColors.blue,
                ),
                const Gap(10),
                Text(
                  label,
                  style: LuraTextStyles.baseTextStyle.copyWith(
                    color: LuraColors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Gap(30),
              ],
            ),
            if (selected)
              const Align(
                child: Icon(Icons.check, color: LuraColors.blue),
                alignment: Alignment.centerRight,
              ),
          ],
        ),
      ),
    );
  }
}
