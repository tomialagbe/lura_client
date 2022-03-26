import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';
import 'package:lura_client/ui/widgets/lura_action_button.dart';
import 'package:lura_client/ui/widgets/lura_primary_button.dart';
import 'package:widgetbook/widgetbook.dart';

class ButtonsCategory extends WidgetbookCategory {
  ButtonsCategory() : super(name: 'Buttons', widgets: buttonWidgets());
}

List<WidgetbookWidget> buttonWidgets() {
  return [
    WidgetbookWidget(
        name: '$LuraActionButton', useCases: luraActionButtonUseCases()),
    WidgetbookWidget(
        name: '$LuraCircularIconButton',
        useCases: circularIconButtonUseCases()),
    WidgetbookWidget(
        name: '$LuraPrimaryButton', useCases: primaryButtonUseCases()),
    WidgetbookWidget(name: 'Text buttons', useCases: textButtonUseCases()),
  ];
}

List<WidgetbookUseCase> luraActionButtonUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default action button',
      builder: (_) => const LuraActionButton(
        text: 'Get started',
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom width',
      builder: (_) => const LuraActionButton(
        text: 'Go',
        width: 170,
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom icon',
      builder: (_) => const LuraActionButton(
        text: 'Save',
        actionIcon: Icons.save,
      ),
    ),
    WidgetbookUseCase(
      name: 'Alt colors',
      builder: (_) => const LuraActionButton(
        text: 'Join waitlist',
        bottomColor: Color(0xFFEEEEEE),
        topColor: Colors.white,
        defaultTextColor: Colors.black,
        highlightTextColor: Colors.black,
      ),
    ),
  ];
}

List<WidgetbookUseCase> circularIconButtonUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (_) => LuraCircularIconButton(
        icon: Icons.arrow_forward,
        onTap: () {},
      ),
    ),
    WidgetbookUseCase(
      name: 'Custom size',
      builder: (_) => LuraCircularIconButton(
        icon: Icons.arrow_forward,
        size: 55,
        onTap: () {},
      ),
    ),
  ];
}

List<WidgetbookUseCase> primaryButtonUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (_) => LuraPrimaryButton(
        text: 'Get started now',
        onTap: () {},
      ),
    ),
    WidgetbookUseCase(
      name: 'With icon',
      builder: (_) => LuraPrimaryButton(
        text: 'Get started now',
        leadingIcon: Icons.play_arrow,
        onTap: () {},
      ),
    ),
  ];
}

List<WidgetbookUseCase> textButtonUseCases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (_) => TextButton(
        onPressed: () {},
        child: Text('Login'),
      ),
    ),
  ];
}
