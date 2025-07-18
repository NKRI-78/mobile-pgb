import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:mobile_pgb/misc/injections.dart';

class MyRemoteConfig {
  static FirebaseRemoteConfig? remoteConfig;
  static Future<void> init() async {
    try {
      remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig?.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await remoteConfig?.setDefaults({
        'is_review_apple': false,
      });

      await remoteConfig?.fetchAndActivate();

      final message = remoteConfig?.getString('is_review_apple');

      getIt.registerLazySingleton<FirebaseRemoteConfig>(() => remoteConfig!);

      print('Message: $message');
    } catch (e) {
      print("ERROR APA INI");
      print(e);
    }
  }
}
