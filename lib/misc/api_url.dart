import 'flavor_config.dart';

class MyApi {
  static String get baseUrl => FlavorConfig.instance.baseUrl;
  static String get baseUrlSocket => FlavorConfig.instance.baseUrlSocket;
  static String get baseUrlPpob => FlavorConfig.instance.baseUrlPpob;
  static String get baseUrlUpload => FlavorConfig.instance.baseUrlUpload;
  static String get baseUrlBiteship => FlavorConfig.instance.baseUrlBiteship;
}
