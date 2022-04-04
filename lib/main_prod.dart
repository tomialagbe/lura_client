import 'package:lura_client/lura_config.dart';

import 'firebase_options_prod.dart';
import 'main.dart' as m;

final _config = LuraConfig(
    serverUrl: 'https://app.lura.so',
    firebaseOptions: ProdFirebaseOptions.currentPlatform);

void main() => m.main(config: _config);
