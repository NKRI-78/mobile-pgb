import 'dart:ui';

class KtpGuideConfig {
  const KtpGuideConfig._();

  // Ubah angka-angka ini kalau mau geser atau resize boundary di preview.
  static const double cardWidthFactor = 0.9;
  static const double cardAspectRatio = 1.58;
  static const double cardTopFactor = 0.18;

  static const double nikLeftFactor = 0.20;
  static const double nikTopFactor = 0.12;
  static const double nikWidthFactor = 0.48;
  static const double nikHeightFactor = 0.12;

  static const double faceLeftFactor = 0.70;
  static const double faceTopFactor = 0.22;
  static const double faceWidthFactor = 0.24;
  static const double faceHeightFactor = 0.50;
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
  });

  final Rect cardRect;
  final Rect nikRect;
  final Rect faceRect;

  static KtpGuideLayout fromSize(Size size) {
    final cardWidth = size.width * KtpGuideConfig.cardWidthFactor;
    final cardHeight = cardWidth / KtpGuideConfig.cardAspectRatio;
    final cardLeft = (size.width - cardWidth) / 2;
    final cardTop = (size.height - cardHeight) / 2;
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

    return KtpGuideLayout(
      cardRect: cardRect,
      nikRect: nikRect,
      faceRect: faceRect,
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
