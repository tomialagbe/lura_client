import 'package:flutter/material.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:widgetbook/widgetbook.dart';

class TypographyCategory extends WidgetbookCategory {
  TypographyCategory()
      : super(
          name: 'Text styles',
          widgets: [
            WidgetbookWidget(
              name: 'Text Styles',
              useCases: textStyles(),
            ),
          ],
        );
}

List<WidgetbookUseCase> textStyles() {
  return [
    _useCaseForTextStyle('Heading1', LuraTextStyles.heading1),
    _useCaseForTextStyle('Heading2', LuraTextStyles.heading2),
    _useCaseForTextStyle('Heading3', LuraTextStyles.heading3),
    _useCaseForTextStyle('Heading4', LuraTextStyles.heading4),
    _useCaseForTextStyle('Heading5', LuraTextStyles.heading5),
  ];
}

WidgetbookUseCase _useCaseForTextStyle(String title, TextStyle textStyle) {
  return WidgetbookUseCase(
    name: title,
    builder: (_) => Text(
      title,
      style: textStyle,
    ),
  );
}
