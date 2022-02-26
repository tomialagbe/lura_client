import 'package:bonsoir/bonsoir.dart';
import 'package:flutter/material.dart';
import 'package:mobile_printer/ipp/printer.dart';

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

  // BonsoirBroadcast? broadcast;
  Printer? printer;

  Future stopServer() async {
    // broadcast?.stop();
    printer?.stop();
  }

  Future startServer() async {
    try {
      printer = Printer(name: 'LuraPrinter', port: 8089);
      printer?.start();
    } catch (err, st) {
      debugPrint(err.toString());
      debugPrint(st.toString());
    }
  }

  @override
  void dispose() {
    // Then if you want to stop the broadcast :
    // broadcast?.stop();
    super.dispose();
  }
}
