import 'dart:collection';

import 'ipp_constants.dart';
import 'ipp_message.dart';

// ignore: non_constant_identifier_names
final ATTR_GROUPS = [
  'all',
  'job-template',
  'job-description',
  'printer-description'
];

// ignore: non_constant_identifier_names
var ATTR_GROUP_PRINTER_DESC = [
  'printer-uri-supported',
  'uri-security-supported',
  'uri-authentication-supported',
  'printer-name',
  'printer-location',
  'printer-info',
  'printer-more-info',
  'printer-driver-installer',
  'printer-make-and-model',
  'printer-more-info-manufacturer',
  'printer-state',
  'printer-state-reasons',
  'printer-state-message',
  'ipp-versions-supported',
  'operations-supported',
  'multiple-document-jobs-supported',
  'charset-configured',
  'charset-supported',
  'natural-language-configured',
  'generated-natural-language-supported',
  'document-format-default',
  'document-format-supported',
  'printer-is-accepting-jobs',
  'queued-job-count',
  'printer-message-from-operator',
  'color-supported',
  'reference-uri-schemes-supported',
  'pdl-override-supported',
  'printer-up-time',
  'printer-current-time',
  'multiple-operation-time-out',
  'compression-supported',
  'job-k-octets-supported',
  'job-impressions-supported',
  'job-media-sheets-supported',
  'pages-per-minute',
  'pages-per-minute-color'
];

// ignore: non_constant_identifier_names
final ATTR_GROUP_JOB_TMPL = [
  'job-priority',
  'job-hold-until',
  'job-sheets',
  'multiple-document-handling',
  'copies',
  'finishings',
  'page-ranges',
  'sides',
  'number-up',
  'orientation-requested',
  'media',
  'printer-resolution',
  'print-quality'
];

// ignore: non_constant_identifier_names
final ATTR_GROUP_JOB_DESC = [
  'job-uri',
  'job-id',
  'job-printer-uri',
  'job-more-info',
  'job-name',
  'job-originating-user-name',
  'job-state',
  'job-state-reasons',
  'job-state-message',
  'job-detailed-status-messages',
  'job-document-access-errors',
  'number-of-documents',
  'output-device-assigned',
  'time-at-creation',
  'time-at-processing',
  'time-at-completed',
  'job-printer-up-time',
  'date-time-at-creation',
  'date-time-at-processing',
  'date-time-at-completed',
  'number-of-intervening-jobs',
  'job-message-from-operator',
  'job-k-octets',
  'job-impressions',
  'job-media-sheets',
  'job-k-octets-processed',
  'job-impressions-completed',
  'job-media-sheets-completed',
  'attributes-charset',
  'attributes-natural-language'
];

abstract class Utils {
  static int time(DateTime startedUtc, DateTime nowUtc) {
    final startedTs = startedUtc.millisecondsSinceEpoch;
    final nowTs = nowUtc.millisecondsSinceEpoch;
    return ((nowTs - startedTs) / 1000).floor();
  }

  static List<String>? requestedAttributes(IppMessage request) {
    List<String>? result;
    request.groups.firstWhere((AttributeGroup group) {
      if (group.tag == IppConstants.OPERATION_ATTRIBUTES_TAG) {
        group.attributes.firstWhere((attribute) {
          if (attribute.name == 'requested-attributes') {
            result = attribute.value.map((e) => e as String).toList();
            return true;
          }
          return false;
        },
            orElse: () =>
                Attribute()); // return empty attribute  since we don't use return value
        return true;
      }
      return false;
    },
        orElse: () =>
            AttributeGroup()); // return empty attribute group since we don't use return value
    return result;
  }

  static List<String> expandAttrGroups(List<dynamic> attrs) {
    if (attrs.contains('job-template')) {
      attrs = concat(attrs, ATTR_GROUP_JOB_TMPL);
    }
    if (attrs.contains('job-description')) {
      attrs = concat(attrs, ATTR_GROUP_JOB_DESC);
    }
    if (attrs.contains('printer-description')) {
      attrs = concat(attrs, ATTR_GROUP_PRINTER_DESC);
    }
    return attrs as List<String>;
  }

  static List<String> removeStandardAttributes(List<String> attrs) {
    return attrs.where((attr) {
      return ATTR_GROUPS.contains(attr) ||
          ATTR_GROUP_JOB_TMPL.contains(attr) ||
          ATTR_GROUP_JOB_DESC.contains(attr) ||
          ATTR_GROUP_PRINTER_DESC.contains(attr);
    }).toList();
  }

  static List<Attribute> getAttributesForGroup(IppMessage reqMessage, int tag) {
    AttributeGroup? group;
    for (int i = 0; i < reqMessage.groups.length; i++) {
      if (reqMessage.groups[i].tag == tag) {
        group = reqMessage.groups[i];
        break;
      }
    }

    if (group != null) {
      return group.attributes;
    }
    return [];
  }

  static String? getFirstValueForName(List<Attribute> attributes, String name) {
    Attribute? attribute;
    for (int i = 0; i < attributes.length; i++) {
      if (attributes[i].name == name) {
        attribute = attributes[i];
        break;
      }
    }

    if (attribute != null) {
      return attribute.value[0] is num
          ? '${(attribute.value[0] as int)}'
          : attribute.value[0] as String;
    }
  }

  static List<String> concat(List<dynamic> a, List<dynamic> b) {
    return List.of(
        HashSet<String>(equals: (i, j) => i.toString() == j.toString())
          ..addAll([...a, ...b]));
  }
}
