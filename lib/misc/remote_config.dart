import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'injections.dart';

class MyRemoteConfig {
  static FirebaseRemoteConfig? remoteConfig;

  static Future<void> init() async {
    try {
      remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig?.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await remoteConfig?.setDefaults({
        'is_review_apple': false,
        'is_not_found': false,
      });

      await remoteConfig?.fetchAndActivate();

      getIt.registerLazySingleton<FirebaseRemoteConfig>(() => remoteConfig!);

      print('is_review_apple: ${remoteConfig?.getBool('is_review_apple')}');
      print('is_not_found: ${remoteConfig?.getBool('is_not_found')}');
    } catch (e) {
      print("Remote Config init error: $e");
    }
  }

  static bool get isReviewApple =>
      remoteConfig?.getBool('is_review_apple') ?? false;

  static bool get isNotFound => remoteConfig?.getBool('is_not_found') ?? false;
}
