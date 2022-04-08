import 'package:lura_client/lura_config.dart';

import 'firebase_options_staging.dart';
import 'main.dart' as m;

final _config = LuraConfig(
    env: 'dev',
    serverUrl: 'http://192.168.1.137:8080',
    firebaseOptions: StagingFirebaseOptions.currentPlatform);

void main() => m.main(config: _config);
