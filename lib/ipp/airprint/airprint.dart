import 'dart:io';
import 'dart:isolate';

import 'package:dns/dns.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_printer/ipp/airprint/answer_data_encoders.dart';
import 'package:multicast_dns/multicast_dns.dart';

import 'dns_query_response.dart';
import 'proxied_printer.dart';
import 'type_codec.dart';

class AirPrintIsolateMessage {
  final String nameToLookFor;
  final SendPort sendPort;

  AirPrintIsolateMessage(this.nameToLookFor, this.sendPort);
}

Future startAirprintProxy({required String nameToLookFor}) async {
  final receivePort = ReceivePort();
  final message = AirPrintIsolateMessage(nameToLookFor, receivePort.sendPort);
  await Isolate.spawn(_startProxy, message);
}

Future _startProxy(AirPrintIsolateMessage message) async {
  final interfaces =
      await NetworkInterface.list(type: InternetAddressType.IPv4);
  final address = interfaces[0].addresses[0];
  debugPrint(address.address);
  final proxy = AirprintProxy();
  await proxy.resolvePrinter(address, message.nameToLookFor, () {});

  // TODO: handle comms
  // return proxy;
}

class AirprintProxy {
  ProxiedPrinter? printer;

  static const serviceUniversalIpp = '_universal._sub._ipp._tcp.local';
  static const serviceUniversalIpps = '_universal._sub._ipps._tcp.local';
  static const serviceIpp = '_ipp._tcp.local';
  static const serviceIpps = '_ipps._tcp.local';
  static const proxyService = '_services._dns-sd._udp.local';

  DnsServer? _mdnsServer;
  MDnsClient? _mDnsClient;

  AirprintProxy() {}

  _startMdnsServer() async {
    final mdnsServerAddr =
        InternetAddress('224.0.0.251', type: InternetAddressType.IPv4);
    const mdnsServerPort = 5353;
    final dnsClient = SystemDnsClient();
    _mdnsServer = await DnsServer.bind(
      dnsClient,
      port: mdnsServerPort,
      address: mdnsServerAddr,
      receivedDnsPacket: _onServiceQuery,
    );
  }

  void _onServiceQuery(DnsPacket query, InternetAddress address, int port) {
    final requestId = query.id;
    for (final question in query.questions) {
      debugPrint(
          'AirPrint: DNS Query question #$requestId: ${question.name} -> ${question.type} from ${address.address}:$port');
      // PTR query
      if (question.type == DnsResourceRecord.typeDomainNamePointer) {
        if (question.name == serviceUniversalIpp ||
            question.name == serviceIpp) {
          debugPrint(
              'AirPrint: Handling PTR ipp request #$requestId for: ${question.name}');
          onPrinterListRequest(false, question.name,
              flush: true, requestId: requestId, address: address, port: port);
        } else if (question.name == serviceUniversalIpps ||
            question.name == serviceIpps) {
          debugPrint(
              'AirPrint: Handling PTR ipps request #$requestId for: ${question.name}');
          onPrinterListRequest(true, question.name,
              requestId: requestId, address: address, port: port);
        }
      }

      // Address record
      if (question.type == DnsResourceRecord.typeIp4) {
        if (printer != null) {
          if (printer!.host == question.name) {
            debugPrint(
                'AirPrint: Handling A record request #$requestId for: ${question.name}');
            final response = DnsQueryResponse();
            response.answers.addAll([
              DnsAnswer(
                name: printer!.host,
                type: 'A',
                ttl: 300,
                data: printer!.ipAddr.address,
              ),
            ]);

            debugPrint(
                'Airprint: Responding to question ${question.name} on ${address.address}:$port');
            final responseData = encodeDnsQueryResponse(response);
            _mdnsServer?.respondWithBytes(responseData, address, port);
            debugPrint(
                'Airprint: Successfully responded to question ${question.name}');
          }
        }
      }

      // TXT
      if (question.type == DnsResourceRecord.typeText) {
        if (printer != null) {
          debugPrint(
              'AirPrint: Handling TXT record request for: ${question.name}');
          final response = DnsQueryResponse();
          response.answers.addAll([
            if (question.name == printer!.service) ...[
              DnsAnswer(
                name: printer!.service,
                type: 'TXT',
                ttl: 300,
                data: printer!.compileRecordOptions(),
              ),
              DnsAnswer(
                name: printer!.service,
                type: 'PTR',
                ttl: 300,
                data: printer!.host,
              ),
              DnsAnswer(
                name: printer!.host,
                type: 'A',
                ttl: 300,
                data: printer!.ipAddr.address,
              ),
            ] else if (question.name == printer!.serviceIpps) ...[
              DnsAnswer(
                name: printer!.serviceIpps,
                type: 'TXT',
                ttl: 300,
                data: printer!.compileRecordOptions(),
              ),
              DnsAnswer(
                name: printer!.serviceIpps,
                type: 'PTR',
                ttl: 300,
                data: printer!.host,
              ),
              DnsAnswer(
                name: printer!.host,
                type: 'A',
                ttl: 300,
                data: printer!.ipAddr.address,
              ),
            ]
          ]);

          debugPrint(
              'Airprint: Responding to question ${question.name} on ${address.address}:$port');
          final responseData = encodeDnsQueryResponse(response);
          _mdnsServer?.respondWithBytes(responseData, address, port);
          debugPrint(
              'Airprint: Successfully responded to question ${question.name}');
        }
      }
    }
  }

  void onPrinterListRequest(
    bool useIpps,
    String question, {
    int? requestId,
    bool flush = false,
    required InternetAddress address,
    required int port,
  }) {
    if (printer != null) {
      final response = DnsQueryResponse();
      response.answers.addAll([
        // txt record
        DnsAnswer(
          name: useIpps ? printer!.serviceIpps : printer!.service,
          type: 'TXT',
          flush: flush,
          ttl: 300,
          data: printer!.compileRecordOptions(),
        ),
        // proxy ptr
        DnsAnswer(
          name: proxyService,
          type: 'PTR',
          flush: flush,
          ttl: 300,
          data: useIpps ? serviceIpps : serviceIpp,
        ),
        // universal record, point ipp to service
        DnsAnswer(
          name: useIpps ? serviceUniversalIpps : serviceUniversalIpp,
          type: 'PTR',
          ttl: 300,
          data: useIpps ? printer!.serviceIpps : printer!.service,
        ),
        // ipp record, point ipp to service
        DnsAnswer(
          name: useIpps ? serviceIpps : serviceIpp,
          type: 'PTR',
          ttl: 300,
          data: useIpps ? printer!.serviceIpps : printer!.service,
        ),
        // A record, for host to service
        DnsAnswer(
          name: printer!.host,
          type: 'A',
          flush: flush,
          ttl: 300,
          data: printer!.ipAddr.address,
        ),
        // with subtype record
        DnsAnswer(
          name: useIpps ? printer!.serviceIpps : printer!.service,
          type: 'SRV',
          flush: flush,
          ttl: 300,
          data: SrvRecord(
            port: printer!.port,
            weight: 0,
            priority: 40,
            target: printer!.host,
          ),
        ),
      ]);

      debugPrint(
          'AirPrint: Responding to question ${question} on ${address.address}:$port');
      final responseData = encodeDnsQueryResponse(response);
      _mdnsServer?.respondWithBytes(responseData, address, port);
      debugPrint('AirPrint: Successfully responded to question ${question}');
    }
  }

  void setPrinter(ProxiedPrinter printer) {
    this.printer = printer;
    // onPrinterListRequest(false, flush: true);
    // onPrinterListRequest(true, flush: true);
  }

  Future resolvePrinter(InternetAddress address, String nameToLookFor,
      VoidCallback onResolved) async {
    _mDnsClient = MDnsClient();
    await _mDnsClient!.start();
    await for (final record in _mDnsClient!.lookup<PtrResourceRecord>(
        ResourceRecordQuery.serverPointer('_ipp._tcp.local'))) {
      // final domainName = record.domainName; //LuraPrinterAndroid._ipp._tcp.local
      final recordName = record.name; // _ipp._tcp.local

      await for (final SrvResourceRecord srv in _mDnsClient!
          .lookup<SrvResourceRecord>(
              ResourceRecordQuery.service(record.domainName))) {
        final target = srv.target; // Android-2.local
        final fullName = srv.name; // LuraPrinterAndroid._ipp._tcp.local
        final port = srv.port; // 8089
        var name = fullName.replaceFirst(recordName, '');
        if (name.endsWith('.')) {
          name = name.substring(0, name.length - 1);
        }

        if (nameToLookFor == name) {
          debugPrint(
              'Found Printer $name at on ${address.address}:$port with host $target');
          _mDnsClient?.stop();
          _startMdnsServer();
          setPrinter(ProxiedPrinter(
              ipAddr: address,
              name: name,
              port: port,
              host: target,
              onUpdate: (keys) {
                // onPrinterListRequest(false, flush: true);
                // onPrinterListRequest(true, flush: true);
              }));

          return;
        }
      }
    }
  }

  void stop() {
    _mdnsServer?.close();
    _mDnsClient?.stop();
  }
}
