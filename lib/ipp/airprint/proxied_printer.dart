// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';

// See https://wiki.debian.org/CUPSAirPrint
final defaultProxyOptions = {
  "air": "none",
  "note": "",
  "pdl": "application/vnd.hp-PCL,image/jpeg,application/PCLm,image/urf", //application/vnd.hp-PCL,image/jpeg,application/PCLm,image/urf
  // "pdl": ["image/urf"],
  "rp": "ipp/print",
  "TLS": "",
  "UUID": "",

  //Deprecated Options
  "adminurl": "",
  "priority": 50,
  "product": "(StarTSP654II)",
  "qtotal": 1,
  "txtvers": 1,
  "ty": "StarTSP654II",
  "usb_CMD": "",
  "usb_MDL": "",
  "usb_MFG": "",

  //AirPrint Specific Options
  "URF": "DM3",
  // "URF": "CP1,MT1-2-8-9-10-11,OB9,OFU0,PQ3-4-5,RS300-600,SRGB24,W8-16,DEVW8-16,DEVRGB24-48,ADOBERGB24-48,DM3,IS1,V1.3",

  // 9.3 Printer Capability TXT Record Keys
  "Transparent": "F",
  "Binary": "F",
  "TBCP": "F",
  "kind": "document,photo", // document,envelope,photo
  // "kind": ["document", "photo"],

  // 9.4 Printer Feature TXT Record Keys
  "Color": "T", // TODO
  "Duplex": "U",
  "PaperMax": "<legal-A4",
  "Staple": "U",

  //Deprecated features
  "Bind": "U",
  "Collate": "U",
  "Copies": "U",
  "PaperCustom": "U",
  "Punch": "U",
  "Scan": "F",
  "Sort": "U"
};

typedef ProxiedPrinterOnUpdate = void Function(List<String> keys);

class ProxiedPrinter {
  static const AIR_AUTH_NONE = 'none';
  static const AIR_AUTH_CERTIFICATE = 'certificate';
  static const AIR_AUTH_USER_PASS = 'username,password';
  static const AIR_AUTH_NEGOTIATE = 'negotiate';
  static const AIR_TLS_DEFAULT = '';
  static const AIR_TLS_SUPPORTED = '1.2';

  final InternetAddress ipAddr;
  final String name;
  final int port;
  final String host;

  late String service;
  late String serviceIpps;
  late Map<String, dynamic> presets;
  late String uuid;
  late bool useIpps;
  late Map<String, String> options;

  ProxiedPrinterOnUpdate? onUpdate;

  ProxiedPrinter({
    required this.ipAddr,
    required this.name,
    required this.port,
    required this.host,
    this.onUpdate,
  }) {
    service = '$name._ipp._tcp.local';
    serviceIpps = '$name._ipps._tcp.local';
    presets = defaultProxyOptions;
    uuid = const Uuid().v5(Uuid.NAMESPACE_DNS, host);
    useIpps = false;
    options = {};

    setOption('UUID', value: uuid);
  }

  void setOption(dynamic key, {String? value}) {
    if (key is Map) {
      final mp =
          key.map((key, value) => MapEntry(key.toString(), value.toString()));
      options.addAll(mp);
      // onUpdate?.call(mp.keys.toList());
    } else {
      String keyStr = key as String;
      options[keyStr] = value ?? 'undefined';
    }
  }

  void setOptionBool(String key, {bool? value}) {
    setOption(
      key,
      value: value == null
          ? 'U'
          : value
              ? 'T'
              : 'F',
    );
  }

  void setAuthentication({String? value}) {
    setOption('air', value: value);
  }

  void setTls({String? value}) {
    setOption('TLS', value: value);
  }

  void setQueue({String? value}) {
    setOption('rp', value: value);
  }

  void setNotes({String? value}) {
    setOption('note', value: value ?? '');
  }

  void setLocation({String? value}) => setNotes(value: value);

  void setOptionPresets(Map<String, dynamic> options) {
    presets = options;
  }

  void setPrinterModel({String? model}) {
    model = model ?? '';
    setOption({
      'ty': model,
      'product': '($model)',
    });
  }

  List<String> getSupportedMime() {
    if (options['pdl'] != null) {
      return options['pdl']!.split(',');
    }
    return presets['pdl'] ?? [];
  }

  void addSupportedMime(String mime) {
    final supported = getSupportedMime();
    supported.insert(0, mime);
    setOption('pdl', value: supported.join(','));
  }

  Uint8List compileRecordOptions() {
    final recordOptions = Map<String, dynamic>.from(presets..addAll(options));
    final keyPairs = recordOptions.keys.map((k) {
      final val = recordOptions[k];
      return '$k=${val is List ? val.join(',') : val.toString()}';
    }).toList();

    List<Uint8List> buffers = [];
    for (var pair in keyPairs) {
      final bytes = utf8.encode(pair);
      final len = bytes.length;

      final buf = ByteData(len + 1);
      buf.setUint8(0, len);
      var st = 1;
      for (int i = 0; i < bytes.length; i++) {
        buf.setUint8(st, bytes[i]);
        st++;
      }
      buffers.add(buf.buffer.asUint8List());
    }

    final fullLen = buffers.fold(
        0,
        (int previousValue, Uint8List element) =>
            element.length + previousValue);
    final fullBuffer = ByteData(fullLen);
    var offset = 0;
    for (final buffer in buffers) {
      for (int i = 0; i < buffer.length; i++) {
        fullBuffer.setUint8(offset, buffer[i]);
        offset++;
      }
    }

    return fullBuffer.buffer.asUint8List();
  }
}
