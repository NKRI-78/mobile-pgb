import 'flavor_config.dart';

class MyApi {
  // static const baseUrl = "https://api-stag-gema.langitdigital78.com";
  // static const baseUrlPpob = "https://api-ppob.langitdigital78.com";
  // static const baseUrlUpload = "http://157.245.193.49:3099";
  // static const baseUrlSocket = "http://157.245.193.49:6912";
  // static const baseUrlBiteship = "https://live-biteship.langitdigital78.com";
  // http://157.245.193.49:23001
  static String get baseUrl => FlavorConfig.instance.baseUrl;
  static String get baseUrlSocket => FlavorConfig.instance.baseUrlSocket;
  static String get baseUrlPpob => FlavorConfig.instance.baseUrlPpob;
  static String get baseUrlUpload => FlavorConfig.instance.baseUrlUpload;
  static String get baseUrlBiteship => FlavorConfig.instance.baseUrlBiteship;
}
