import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/theme.dart';
import 'package:mobile_printer/ui/typography.dart';

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
    return Theme(
      data: Theme.of(context)
          .copyWith(elevatedButtonTheme: LuraTheme.invertedElevatedButtonTheme),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PlatformSelectorButton(
              icon: FontAwesomeIcons.apple,
              label: 'iOS',
              onTap: () {
                setState(() {
                  _currentValue = 'iOS';
                });
              },
              selected: _currentValue == 'iOS',
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
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformSelectorButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  const _PlatformSelectorButton({
    Key? key,
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
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
                const Gap(30)
              ],
            ),
            if (selected)
              const Align(
                child: Icon(Icons.check, color: Colors.green),
                alignment: Alignment.centerRight,
              ),
          ],
        ),
      ),
    );
  }
}
