import 'package:lura_client/lura_config.dart';

import 'firebase_options_staging.dart';
import 'main.dart' as m;

final _config = LuraConfig(
    serverUrl: 'http://localhost:8080',
    firebaseOptions: StagingFirebaseOptions.currentPlatform);

void main() => m.main(config: _config);
