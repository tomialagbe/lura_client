import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/theme.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PlatformSelector extends StatefulWidget {
  final String initialValue;
  final Function(String)? onChange;

  const PlatformSelector({
    Key? key,
    this.onChange,
    required this.initialValue,
  }) : super(key: key);

  @override
  State<PlatformSelector> createState() => _PlatformSelectorState();
}

class _PlatformSelectorState extends State<PlatformSelector> {
  String _currentValue = '';

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
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
                _currentValue = 'ios';
              });
              widget.onChange?.call(_currentValue);
            },
            selected: _currentValue == 'ios',
            isDesktop: isDesktop,
          ),
          const Gap(10),
          _PlatformSelectorButton(
            icon: FontAwesomeIcons.android,
            label: 'Android',
            onTap: () {
              setState(() {
                _currentValue = 'android';
              });
              widget.onChange?.call(_currentValue);
            },
            selected: _currentValue == 'android',
            isDesktop: isDesktop,
          ),
          const Gap(10),
          _PlatformSelectorButton(
            icon: FontAwesomeIcons.windows,
            label: 'Windows',
            onTap: () {
              setState(() {
                _currentValue = 'windows';
              });
              widget.onChange?.call(_currentValue);
            },
            selected: _currentValue == 'windows',
            isDesktop: isDesktop,
          ),
        ];

        return sizingInformation.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              )
            : Row(children: children);
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
                  color: Colors.white,
                ),
                const Gap(10),
                Text(
                  label,
                  style: LuraTextStyles.baseTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Gap(30),
              ],
            ),
            if (selected)
              const Align(
                child: Icon(Icons.check, color: Colors.white),
                alignment: Alignment.centerRight,
              ),
          ],
        ),
      ),
    );
  }
}
