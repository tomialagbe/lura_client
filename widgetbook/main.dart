import 'package:flutter/material.dart';
import 'package:lura_client/ui/theme.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:widgetbook/widgetbook.dart';

import 'alerts_category.dart';
import 'buttons.dart';
import 'list_items.dart';
import 'text_fields.dart';
import 'text_styles.dart';

void main() {
  runApp(const WidgetbookHotReload());
}

class WidgetbookHotReload extends StatelessWidget {
  const WidgetbookHotReload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      appInfo: AppInfo(name: 'Lura Widgetbook'),
      lightTheme: LuraTheme.defaultTheme,
      defaultTheme: ThemeMode.light,
      devices: const [
        Apple.iPhone11,
        Apple.iPhone11ProMax,
        Apple.iPhone6,
        Apple.iPad9Inch,
        Samsung.s10,
        Desktop.desktop720p,
        Desktop.desktop1080p,
      ],
      categories: [
        TypographyCategory(),
        TextFieldsCategory(),
        ButtonsCategory(),
        ListItemsCategory(),
        AlertsCategory(),
      ],
    );
  }
}
