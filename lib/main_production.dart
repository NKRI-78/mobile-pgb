import 'main.dart' as app;
import 'misc/flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.production,
    name: "PRODUCTION",
    baseUrl: "https://api-stag-gema.langitdigital78.com",
    baseUrlSocket: "http://157.245.193.49:6912",
    baseUrlPpob: "https://api-ppob.langitdigital78.com",
    baseUrlUpload: "http://157.245.193.49:3099",
    baseUrlBiteship: "https://live-biteship.langitdigital78.com",
  );

  app.main();
}
