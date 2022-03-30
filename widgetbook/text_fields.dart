import 'package:flutter/material.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/widgets/lura_rounded_text_field.dart';
import 'package:lura_client/ui/widgets/lura_text_field.dart';
import 'package:widgetbook/widgetbook.dart';

class TextFieldsCategory extends WidgetbookCategory {
  TextFieldsCategory()
      : super(
          name: 'Text fields',
          widgets: [
            WidgetbookWidget(
              name: '$LuraRoundedTextField',
              useCases: roundedTextFields(),
            ),
            WidgetbookWidget(
              name: '$LuraTextField',
              useCases: textFields(),
            ),
          ],
        );
}

List<WidgetbookUseCase> textFields() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: LuraTextField(),
      ),
    ),
    WidgetbookUseCase(
      name: 'With hint',
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: LuraTextField(hintText: 'Your email'),
      ),
    ),
    WidgetbookUseCase(
      name: 'With trailing icon',
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: LuraTextField(
          hintText: 'Your email',
          trailing: Icon(Icons.alternate_email),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Large',
      builder: (_) => const Padding(
        padding: EdgeInsets.all(20),
        child: LuraTextField(
          hintText: 'Your email',
          large: true,
        ),
      ),
    ),
  ];
}

List<WidgetbookUseCase> roundedTextFields() {
  return [
    WidgetbookUseCase(
      name: 'Basic',
      builder: (_) => _wrapForm(const LuraRoundedTextField()),
    ),
    WidgetbookUseCase(
      name: 'With hint',
      builder: (_) => _wrapForm(
        const LuraRoundedTextField(
          hintText: 'Enter your email',
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With action',
      builder: (_) => _wrapForm(
        LuraActionTextField(
          hintText: 'Enter your email',
          icon: Icons.arrow_forward,
          onTap: () {},
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'With error',
      builder: (_) => _wrapForm(
        StatefulBuilder(builder: (context, setState) {
          final _formKey = GlobalKey<FormState>();
          return Form(
            key: _formKey,
            child: LuraActionTextField(
              hintText: 'Enter your email',
              icon: Icons.arrow_forward,
              textInputValidator: (val) {
                if (val == null || val.trim().length < 4) {
                  return 'Input too short';
                }
                return null;
              },
              onTap: () {
                _formKey.currentState?.validate();
              },
            ),
          );
        }),
      ),
    ),
    WidgetbookUseCase(
      name: 'Large text fields',
      builder: (_) => _wrapForm(
        LuraActionTextField(
          hintText: 'Enter your email',
          icon: Icons.arrow_forward,
          onTap: () {},
          large: true,
        ),
      ),
    ),
  ];
}

Widget _wrapForm(Widget form) {
  return Container(
      padding: const EdgeInsets.all(30),
      color: LuraColors.formBackground,
      child: form);
}
