import 'dart:ui';

class KtpGuideConfig {
  const KtpGuideConfig._();

  static const double cardWidthFactor = 0.5;
  static const double cardAspectRatio = 1.58;

  // HEADER
  static const double headerLeftFactor = 0.17;
  static const double headerTopFactor = 0.015;
  static const double headerWidthFactor = 0.65;
  static const double headerHeightFactor = 0.12;

  // NIK
  static const double nikLeftFactor = 0.24;
  static const double nikTopFactor = 0.145;
  static const double nikWidthFactor = 0.47;
  static const double nikHeightFactor = 0.085;

  // BIODATA
  static const double biodataLeftFactor = 0.02;
  static const double biodataTopFactor = 0.24;
  static const double biodataWidthFactor = 0.69;
  static const double biodataHeightFactor = 0.60;

  // FOTO
  static const double faceLeftFactor = 0.725;
  static const double faceTopFactor = 0.2;
  static const double faceWidthFactor = 0.235;
  static const double faceHeightFactor = 0.47;
}

class KtpCaptureValidation {
  const KtpCaptureValidation({
    required this.isValid,
    required this.message,
    required this.blurScore,
    required this.textCoverage,
    required this.nikInsideGuide,
    this.processedImagePath,
  });

  final bool isValid;
  final String message;
  final double blurScore;
  final double textCoverage;
  final bool nikInsideGuide;
  final String? processedImagePath;
}

class KtpGuideLayout {
  const KtpGuideLayout({
    required this.cardRect,
    required this.nikRect,
    required this.faceRect,
    required this.headerRect,
    required this.biodataRect,
  });

  final Rect cardRect;
  final Rect nikRect;
  final Rect faceRect;
  final Rect headerRect;
  final Rect biodataRect;

  static KtpGuideLayout fromSize(Size size) {
    final cardWidth = size.width * KtpGuideConfig.cardWidthFactor;
    final cardHeight = cardWidth / KtpGuideConfig.cardAspectRatio;
    final cardLeft = (size.width - cardWidth) / 2;
    final cardTop = (size.height - cardHeight) / 1.5;
    final cardRect = Rect.fromLTWH(
      cardLeft,
      cardTop,
      cardWidth,
      cardHeight,
    );
    final faceRect = Rect.fromLTWH(
      cardRect.left + (cardRect.width * KtpGuideConfig.faceLeftFactor),
      cardRect.top + (cardRect.height * KtpGuideConfig.faceTopFactor),
      cardRect.width * KtpGuideConfig.faceWidthFactor,
      cardRect.height * KtpGuideConfig.faceHeightFactor,
    );

    final nikRect = Rect.fromLTWH(
      cardRect.left + (cardRect.width * KtpGuideConfig.nikLeftFactor),
      cardRect.top + (cardRect.height * KtpGuideConfig.nikTopFactor),
      cardRect.width * KtpGuideConfig.nikWidthFactor,
      cardRect.height * KtpGuideConfig.nikHeightFactor,
    );

    final headerRect = Rect.fromLTWH(
      cardRect.left + (cardRect.width * KtpGuideConfig.headerLeftFactor),
      cardRect.top + (cardRect.height * KtpGuideConfig.headerTopFactor),
      cardRect.width * KtpGuideConfig.headerWidthFactor,
      cardRect.height * KtpGuideConfig.headerHeightFactor,
    );

    final biodataRect = Rect.fromLTWH(
      cardRect.left + (cardRect.width * KtpGuideConfig.biodataLeftFactor),
      cardRect.top + (cardRect.height * KtpGuideConfig.biodataTopFactor),
      cardRect.width * KtpGuideConfig.biodataWidthFactor,
      cardRect.height * KtpGuideConfig.biodataHeightFactor,
    );

    return KtpGuideLayout(
      cardRect: cardRect,
      nikRect: nikRect,
      faceRect: faceRect,
      headerRect: headerRect,
      biodataRect: biodataRect,
    );
  }

  static Rect mapScreenRectToImageRect({
    required Rect screenRect,
    required Size screenSize,
    required Size imageSize,
  }) {
    final sourceAspect = imageSize.width / imageSize.height;
    final screenAspect = screenSize.width / screenSize.height;

    late final double displayedWidth;
    late final double displayedHeight;
    late final double offsetX;
    late final double offsetY;

    if (sourceAspect > screenAspect) {
      displayedHeight = screenSize.height;
      displayedWidth = displayedHeight * sourceAspect;
      offsetX = (displayedWidth - screenSize.width) / 2;
      offsetY = 0;
    } else {
      displayedWidth = screenSize.width;
      displayedHeight = displayedWidth / sourceAspect;
      offsetX = 0;
      offsetY = (displayedHeight - screenSize.height) / 2;
    }

    double mapX(double x) =>
        ((x + offsetX) / displayedWidth * imageSize.width).clamp(
          0,
          imageSize.width,
        );
    double mapY(double y) =>
        ((y + offsetY) / displayedHeight * imageSize.height).clamp(
          0,
          imageSize.height,
        );

    final left = mapX(screenRect.left);
    final top = mapY(screenRect.top);
    final right = mapX(screenRect.right);
    final bottom = mapY(screenRect.bottom);

    return Rect.fromLTRB(left, top, right, bottom);
  }
}
