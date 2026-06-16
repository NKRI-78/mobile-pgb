import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

import '../model/ktp_capture_validation.dart';

class KtpCaptureAnalyzer {
  KtpCaptureAnalyzer._();

  static const double _minimumBlurScore = 120;

  static Future<KtpCaptureValidation> validate({
    required String imagePath,
    required Size screenSize,
  }) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      return const KtpCaptureValidation(
        isValid: false,
        message: 'Foto KTP tidak ditemukan. Silakan ambil ulang.',
        blurScore: 0,
        textCoverage: 0,
        nikInsideGuide: false,
      );
    }

    final bytes = await file.readAsBytes();
    final rawImage = img.decodeImage(bytes);
    if (rawImage == null) {
      return const KtpCaptureValidation(
        isValid: false,
        message: 'Foto KTP gagal dibaca. Silakan ambil ulang.',
        blurScore: 0,
        textCoverage: 0,
        nikInsideGuide: false,
      );
    }

    final decodedImage = img.bakeOrientation(rawImage);

    final imageSize = Size(
      decodedImage.width.toDouble(),
      decodedImage.height.toDouble(),
    );
    final guideLayout = KtpGuideLayout.fromSize(screenSize);
    final mappedCardRect = KtpGuideLayout.mapScreenRectToImageRect(
      screenRect: guideLayout.cardRect,
      screenSize: screenSize,
      imageSize: imageSize,
    );

    final croppedCardImage = _cropToRect(decodedImage, mappedCardRect);
    final processedImagePath = await _writeCroppedImage(
      sourcePath: imagePath,
      image: croppedCardImage,
    );

    final blurScore = _estimateBlurScore(croppedCardImage);
    if (blurScore < _minimumBlurScore) {
      return KtpCaptureValidation(
        isValid: false,
        message: 'Foto KTP masih buram. Coba tahan kamera lebih stabil.',
        blurScore: blurScore,
        textCoverage: 0,
        nikInsideGuide: false,
        processedImagePath: processedImagePath,
      );
    }

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognizedText = await recognizer.processImage(
        InputImage.fromFilePath(processedImagePath),
      );

      final lines = recognizedText.blocks
          .expand((block) => block.lines)
          .where((line) => line.text.trim().isNotEmpty)
          .toList();

      if (lines.length < 15) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'Data KTP belum terbaca dengan jelas. Dekatkan kamera dan pastikan pencahayaan cukup.',
          blurScore: blurScore,
          textCoverage: 0,
          nikInsideGuide: false,
          processedImagePath: processedImagePath,
        );
      }

      final textCoverage = _estimateTextCoverage(lines, croppedCardImage);
      final totalCharacters = lines.fold<int>(
        0,
        (sum, line) => sum + line.text.trim().length,
      );

      print('totalCharacters=$totalCharacters');

      if (totalCharacters < 150) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'Data KTP belum terbaca lengkap. Dekatkan kamera dan pastikan seluruh data terlihat jelas.',
          blurScore: blurScore,
          textCoverage: textCoverage,
          nikInsideGuide: false,
          processedImagePath: processedImagePath,
        );
      }

      if (textCoverage < 0.18) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'Teks KTP belum cukup jelas terbaca. Dekatkan kamera dan pastikan seluruh data terlihat tajam.',
          blurScore: blurScore,
          textCoverage: textCoverage,
          nikInsideGuide: false,
          processedImagePath: processedImagePath,
        );
      }

      print('textCoverage=$textCoverage');
      print('blurScore=$blurScore');
      for (final line in lines) {
        print('OCR: ${line.text}');
      }
      final nikLine = _findNikLine(lines);
      print('nikLine=${nikLine?.text}');
      if (nikLine == null) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'NIK belum terbaca 16 digit. Pastikan bagian atas KTP terlihat jelas.',
          blurScore: blurScore,
          textCoverage: textCoverage,
          nikInsideGuide: false,
          processedImagePath: processedImagePath,
        );
      }

      final keywordMatches = _countKtpKeywords(lines);

      print('keywordMatches=$keywordMatches');

      if (keywordMatches < 4) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'Foto belum menampilkan struktur KTP dengan jelas. Coba rapikan posisi dan pencahayaan.',
          blurScore: blurScore,
          textCoverage: textCoverage,
          nikInsideGuide: true,
          processedImagePath: processedImagePath,
        );
      }

      return KtpCaptureValidation(
        isValid: true,
        message: 'Foto KTP siap diproses.',
        blurScore: blurScore,
        textCoverage: textCoverage,
        nikInsideGuide: true,
        processedImagePath: processedImagePath,
      );
    } finally {
      await recognizer.close();
    }
  }

  static img.Image _cropToRect(img.Image image, Rect rect) {
    final left = rect.left.round().clamp(0, image.width - 1);
    final top = rect.top.round().clamp(0, image.height - 1);
    final width = rect.width.round().clamp(1, image.width - left);
    final height = rect.height.round().clamp(1, image.height - top);

    return img.copyCrop(
      image,
      x: left,
      y: top,
      width: width,
      height: height,
    );
  }

  static Future<String> _writeCroppedImage({
    required String sourcePath,
    required img.Image image,
  }) async {
    final sourceFile = File(sourcePath);
    final targetPath = sourceFile.path.replaceFirstMapped(
      RegExp(r'(\.\w+)?$'),
      (match) => '_ktp_boundary.jpg',
    );
    final targetFile = File(targetPath);
    await targetFile.writeAsBytes(
      img.encodeJpg(image, quality: 92),
      flush: true,
    );
    return targetFile.path;
  }

  static double _estimateBlurScore(img.Image source) {
    final resized =
        source.width > 1200 ? img.copyResize(source, width: 1200) : source;

    double total = 0;
    double totalSquared = 0;
    int count = 0;

    for (var y = 1; y < resized.height - 1; y += 2) {
      for (var x = 1; x < resized.width - 1; x += 2) {
        final center = resized.getPixel(x, y);
        final left = resized.getPixel(x - 1, y);
        final right = resized.getPixel(x + 1, y);
        final top = resized.getPixel(x, y - 1);
        final bottom = resized.getPixel(x, y + 1);

        final laplacian = (_luma(left) +
                _luma(right) +
                _luma(top) +
                _luma(bottom) -
                (4 * _luma(center)))
            .abs();

        total += laplacian;
        totalSquared += laplacian * laplacian;
        count++;
      }
    }

    if (count == 0) {
      return 0;
    }

    final mean = total / count;
    return max((totalSquared / count) - (mean * mean), 0);
  }

  static double _luma(img.Pixel pixel) {
    return (0.299 * pixel.r) + (0.587 * pixel.g) + (0.114 * pixel.b);
  }

  static double _estimateTextCoverage(List<TextLine> lines, img.Image image) {
    double coveredArea = 0;
    for (final line in lines) {
      coveredArea += line.boundingBox.width * line.boundingBox.height;
    }

    final imageArea = max((image.width * image.height).toDouble(), 1);
    return (coveredArea / imageArea).clamp(0, 1);
  }

  static int _countKtpKeywords(List<TextLine> lines) {
    const keywords = [
      'NIK',
      'NAMA',
      'ALAMAT',
      'KECAMATAN',
      'KELURAHAN',
      'AGAMA',
      'PEKERJAAN',
      'RT/RW',
    ];

    int count = 0;

    for (final line in lines) {
      final text = line.text.toUpperCase();

      for (final keyword in keywords) {
        if (text.contains(keyword)) {
          count++;
          break;
        }
      }
    }

    return count;
  }

  static TextLine? _findNikLine(List<TextLine> lines) {
    for (final line in lines) {
      final digits = line.text.replaceAll(RegExp(r'[^0-9]'), '');

      print('LINE=${line.text}');
      print('DIGITS=$digits');

      if (digits.length >= 14) {
        return line;
      }
    }

    return null;
  }
}
