import 'package:flutter/src/widgets/basic.dart';
import 'package:lura_client/ui/widgets/lura_alerts/alerts.dart';
import 'package:widgetbook/widgetbook.dart';

class AlertsCategory extends WidgetbookCategory {
  AlertsCategory()
      : super(
          name: 'Alerts',
          widgets: [
            WidgetbookWidget(
              name: 'Alerts',
              useCases: alertUsecases(),
            ),
          ],
        );
}

List<WidgetbookUseCase> alertUsecases() {
  return [
    WidgetbookUseCase(
      name: 'Success alert',
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: LuraSuccessAlert(
            title: 'Congratulations!',
            message: 'The printer has just been created.'),
      ),
    ),
    WidgetbookUseCase(
      name: 'Info alert',
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: LuraInfoAlert(
            title: 'Did you know?',
            message: 'Lura works with all POS software'),
      ),
    ),
    WidgetbookUseCase(
      name: 'Warning alert',
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: LuraWarningAlert(
            title: 'Warning', message: 'Be careful before you do this.'),
      ),
    ),
    WidgetbookUseCase(
      name: 'Error alert',
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: LuraErrorAlert(
          title: 'Error!',
          message: 'The program has turned off.',
          actionText: 'Try again',
          onAction: () {},
        ),
      ),
    )
  ];
}
