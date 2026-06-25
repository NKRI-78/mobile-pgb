enum Flavor { staging, production }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;
  final String baseUrlSocket;
  final String baseUrlPpob;
  final String baseUrlUpload;
  final String baseUrlBiteship;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String baseUrl,
    required String baseUrlSocket,
    required String baseUrlPpob,
    required String baseUrlUpload,
    required String baseUrlBiteship,
  }) {
    _instance = FlavorConfig._internal(
      flavor,
      name,
      baseUrl,
      baseUrlSocket,
      baseUrlPpob,
      baseUrlUpload,
      baseUrlBiteship,
    );
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.name,
    this.baseUrl,
    this.baseUrlSocket,
    this.baseUrlPpob,
    this.baseUrlUpload,
    this.baseUrlBiteship,
  );

  static FlavorConfig get instance => _instance!;

  static bool get isStaging => _instance?.flavor == Flavor.staging;
  static bool get isProduction => _instance?.flavor == Flavor.production;
}
