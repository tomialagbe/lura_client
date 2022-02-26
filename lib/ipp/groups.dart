import 'package:mobile_printer/ipp/ipp_message.dart';
import 'package:mobile_printer/ipp/type_codec.dart';

import 'constants.dart';
import 'utils.dart';

abstract class Groups {
  static AttributeGroup operationAttributesTag(String status) {
    final group = AttributeGroup()
      ..tag = IppConstants.OPERATION_ATTRIBUTES_TAG
      ..attributes = [
        Attribute.from(
            tag: IppConstants.CHARSET,
            name: 'attributes-charset',
            value: ['utf-8']),
        Attribute.from(
            tag: IppConstants.NATURAL_LANG,
            name: 'attributes-natural-language',
            value: ['en-us']),
        Attribute.from(
            tag: IppConstants.TEXT_WITH_LANG,
            name: 'status-message',
            value: [LangStr(lang: 'en-us', value: status)]),
      ];
    return group;
  }

  static AttributeGroup unsupportedAttributesTag(
      List<Attribute> attributes, List<String> requested) {
    return AttributeGroup()
      ..tag = IppConstants.UNSUPPORTED_ATTRIBUTES_TAG
      ..attributes = _unsupportedAttributes(attributes, requested);
  }

  static AttributeGroup printerAttributesTag(List<Attribute> attributes) {
    return AttributeGroup()
      ..tag = IppConstants.PRINTER_ATTRIBUTES_TAG
      ..attributes = attributes;
  }

  static List<Attribute> _unsupportedAttributes(
      List<Attribute> attributes, List<String> requested) {
    final supported = attributes.map((attr) {
      return attr.name;
    });

    if (requested.isEmpty) {
      return [];
    }

    requested = Utils.removeStandardAttributes(requested);

    return requested.where((name) {
      return !supported.contains(name);
    }).map((name) {
      return Attribute.from(
          tag: IppConstants.UNSUPPORTED, name: name, value: ['unsupported']);
    }).toList();
  }
}
