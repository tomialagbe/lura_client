import 'package:firebase_core/firebase_core.dart';

class LuraConfig {
  final String serverUrl;
  final FirebaseOptions firebaseOptions;

  const LuraConfig({
    required this.serverUrl,
    required this.firebaseOptions,
  });
}
