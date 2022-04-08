import 'package:firebase_core/firebase_core.dart';

class LuraConfig {
  final String env;
  final String serverUrl;
  final FirebaseOptions firebaseOptions;

  const LuraConfig({
    required this.env,
    required this.serverUrl,
    required this.firebaseOptions,
  });
}
