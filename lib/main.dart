import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer/ipp/printer.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Start server'),
                onPressed: () {
                  startServer();
                },
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                child: Text('Stop server'),
                onPressed: () {
                  stopServer();
                },
              ),
            ],
          ),
        ));
  }

  Printer? printer;

  Future stopServer() async {
    printer?.stop();
  }

  Future startServer() async {
    try {
      // TODO: attach device model to printer name
      printer = Printer(
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

  void _onPrintEnd(Uint8List data) async {
    final uuid = const Uuid().v4();
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(data, filename: 'file'),
      'uuid': uuid,
    });
    final response = await Dio()
        .post('http://192.168.1.138:8080/receive', data: formData);
    debugPrint('Received: ${response.statusCode}');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
