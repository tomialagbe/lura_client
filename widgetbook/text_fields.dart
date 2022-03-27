import 'package:flutter/material.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/widgets/lura_text_field.dart';
import 'package:widgetbook/widgetbook.dart';

class TextFieldsCategory extends WidgetbookCategory {
  TextFieldsCategory()
      : super(
          name: 'Text fields',
          widgets: [
            WidgetbookWidget(
              name: 'Text form field',
              useCases: textFormFields(),
            ),
          ],
        );
}

List<WidgetbookUseCase> textFormFields() {
  return [
    WidgetbookUseCase(
      name: 'Basic',
      builder: (_) => _wrapForm(const LuraTextField()),
    ),
    WidgetbookUseCase(
      name: 'With hint',
      builder: (_) => _wrapForm(
        const LuraTextField(
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
