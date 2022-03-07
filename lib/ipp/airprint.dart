import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:multicast_dns/multicast_dns.dart';

class PrinterResolution {
  final InternetAddress address;
  final String name;
  final int port;
  final String host;

  PrinterResolution({
    required this.address,
    required this.name,
    required this.port,
    required this.host,
  });
}

Future<PrinterResolution?> resolvePrinter({required String printerName}) async {
  final interfaces =
      await NetworkInterface.list(type: InternetAddressType.IPv4);
  final address = interfaces[0].addresses[0];
  final mdnsClient = MDnsClient();
  await mdnsClient.start();

  await for (final record in mdnsClient.lookup<PtrResourceRecord>(
      ResourceRecordQuery.serverPointer('_ipp._tcp.local'))) {
    final recordName = record.name; // _ipp._tcp.local
    await for (final SrvResourceRecord srv
        in mdnsClient.lookup<SrvResourceRecord>(
            ResourceRecordQuery.service(record.domainName))) {
      final target = srv.target; // hostname e.g. Android-2.local
      final fullName = srv.name; // LuraPrinterAndroid._ipp._tcp.local
      final port = srv.port; // 8089
      var name = fullName.replaceFirst(recordName, '');
      if (name.endsWith('.')) {
        name = name.substring(0, name.length - 1);
      }

      if (printerName == name) {
        debugPrint(
            'Resolved Printer $name to ${address.address}:$port with host $target');
        mdnsClient.stop();
        return PrinterResolution(
            address: address, name: name, port: port, host: target);
      }
    }
  }
}
