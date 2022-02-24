import 'package:mobile_printer/ipp/ipp_message.dart';
import 'package:mobile_printer/ipp/type_codec.dart';

import 'constants.dart';

AttributeGroup operationAttributesTag(String status) {
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
