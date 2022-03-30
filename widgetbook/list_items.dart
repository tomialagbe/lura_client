import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lura_client/ui/widgets/lura_list_item.dart';
import 'package:widgetbook/widgetbook.dart';

class ListItemsCategory extends WidgetbookCategory {
  ListItemsCategory() : super(name: 'List items', widgets: listItemWidgets());
}

List<WidgetbookWidget> listItemWidgets() {
  return [WidgetbookWidget(name: 'List items', useCases: listItemUsecases())];
}

List<WidgetbookUseCase> listItemUsecases() {
  return [
    WidgetbookUseCase(
      name: 'Default',
      builder: (_) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                children: [
                  LuraListItem(
                    onTap: () {},
                    title: const Text('Printer one'),
                  ),
                  const SizedBox(height: 30),
                  LuraListItem(
                    onTap: () {},
                    title: const Text('Printer one'),
                    subTitle: const Text('about printer one'),
                  ),
                  const SizedBox(height: 30),
                  LuraListItem(
                    onTap: () {},
                    title: const Text('Printer two'),
                    subTitle: const Icon(FontAwesomeIcons.microsoft),
                  ),
                  const SizedBox(height: 30),
                  LuraListItem(
                    onTap: () {},
                    title: const Text('Printer three'),
                    subTitle: const Icon(FontAwesomeIcons.android),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          width: 10,
                          height: 10,
                        ),
                        const Text('Online'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  LuraListItem(
                    onTap: () {},
                    title: const Text('Printer two'),
                    subTitle: const Icon(FontAwesomeIcons.microsoft),
                    trailing: Text('lorem ipsum dolor sit amet lorem ipsum'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
  ];
}
