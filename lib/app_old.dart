import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'printing/esc/esc_pos_printer.dart';
import 'printing/ipp/ipp_printer.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _enableAirprint = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Enable airprint'),
                  const SizedBox(width: 5),
                  Checkbox(
                    value: _enableAirprint,

                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _enableAirprint = val;
                        });
                      }
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Start server'),
                    onPressed: () {
                      startServer();
                      // startEscServer();
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    child: Text('Stop server'),
                    onPressed: () {
                      stopServer();
                      // stopEscServer();
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  IppPrinter? printer;

  Future stopServer() async {
    printer?.stop();
  }

  Future startServer() async {
    try {
      // TODO: attach device model to printer name
      printer = IppPrinter(
          useAirprint: _enableAirprint,
          name:
          'LuraPrinter${Platform.isIOS ? 'iOS' : Platform.isAndroid ? 'Android' : ''}',
          port: 8089);
      printer?.onPrintEnd = _onPrintEnd;
      printer?.start();
    } catch (err, st) {
      debugPrint(err.toString());
      debugPrint(st.toString());
    }
  }

  EscPosPrinter? escPrinter;
  Future startEscServer() async {
    escPrinter = EscPosPrinter(name: 'LuraPrinter');
    await escPrinter?.start();
  }

  Future stopEscServer() async {
    await escPrinter?.stop();
  }

  void _onPrintEnd(Uint8List data) async {
    final uuid = const Uuid().v4();
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(data, filename: 'file'),
      'uuid': uuid,
    });
    final response =
    await Dio().post('http://192.168.1.138:8080/receive', data: formData);
    debugPrint('Received: ${response.statusCode}');
  }

  @override
  void dispose() {
    super.dispose();
  }
}