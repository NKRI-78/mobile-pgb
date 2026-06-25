import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;

import '../model/ktp_capture_validation.dart';

class KtpCaptureAnalyzer {
  KtpCaptureAnalyzer._();

  static double get _minimumPreviewBlurScore {
    if (Platform.isIOS) {
      return 90;
    }

    return 75;
  }

  static double get _minimumCaptureBlurScore {
    if (Platform.isIOS) {
      return 150;
    }

    return 80;
  }

  static Future<KtpPreviewValidation> validatePreviewFrame({
    required CameraImage cameraImage,
  }) async {
    try {
      final blurScore = _estimatePreviewBlurScore(cameraImage);

      String message = 'Posisikan KTP di dalam frame';

      if (blurScore < 20) {
        message = 'Posisikan KTP di dalam frame';
      } else if (blurScore < 80) {
        message = 'Arahkan kamera ke KTP';
      } else if (blurScore < _minimumPreviewBlurScore) {
        message = 'Tahan KTP dan kamera tetap stabil';
      } else {
        message = 'Menyiapkan foto otomatis...';
      }

      return KtpPreviewValidation(
        isReady: blurScore >= _minimumPreviewBlurScore,
        message: message,
        blurScore: blurScore,
        recognizedLineCount: 0,
        totalCharacters: 0,
        keywordMatches: 0,
        hasNikCandidate: false,
      );
    } catch (e, s) {
      debugPrint('====================');
      debugPrint('PREVIEW ERROR');
      debugPrint(e.toString());
      debugPrint(s.toString());
      debugPrint('====================');

      return const KtpPreviewValidation(
        isReady: false,
        message: 'Sedang membaca frame kamera...',
        blurScore: 0,
        recognizedLineCount: 0,
        totalCharacters: 0,
        keywordMatches: 0,
        hasNikCandidate: false,
      );
    }
  }

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

    debugPrint('processedImagePath=$processedImagePath');
    debugPrint('imageSize=$imageSize');
    debugPrint('mappedCardRect=$mappedCardRect');

    final blurScore = _estimateBlurScore(croppedCardImage);

    debugPrint('====================');
    debugPrint('CAPTURE BLUR');
    debugPrint('blurScore=$blurScore');
    debugPrint('minimum=$_minimumCaptureBlurScore');
    debugPrint('====================');
    if (blurScore < _minimumCaptureBlurScore) {
      debugPrint('GAGAL BLUR');
      return KtpCaptureValidation(
        isValid: false,
        message:
            'Foto KTP masih kurang tajam. Tahan kamera lebih stabil dan pastikan pencahayaan cukup.',
        blurScore: blurScore,
        textCoverage: 0,
        nikInsideGuide: false,
        processedImagePath: processedImagePath,
      );
    }
    debugPrint('MASUK OCR');
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final recognizedText = await recognizer.processImage(
        InputImage.fromFilePath(processedImagePath),
      );

      debugPrint('OCR BERHASIL');

      final lines = recognizedText.blocks
          .expand((block) => block.lines)
          .where((line) => line.text.trim().isNotEmpty)
          .toList();

      if (lines.length < 12) {
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

      debugPrint('totalCharacters=$totalCharacters');

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

      // TAMBAHKAN DI SINI
      final meaningfulLines = lines
          .where(
            (e) => e.text.trim().length >= 5,
          )
          .length;

      debugPrint('meaningfulLines=$meaningfulLines');

      if (meaningfulLines < 10) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'Teks KTP belum terbaca dengan jelas. Hindari bayangan dan gunakan pencahayaan yang lebih terang.',
          blurScore: blurScore,
          textCoverage: textCoverage,
          nikInsideGuide: false,
          processedImagePath: processedImagePath,
        );
      }

      debugPrint('====================');
      debugPrint('lines=${lines.length}');
      debugPrint('totalCharacters=$totalCharacters');
      debugPrint('meaningfulLines=$meaningfulLines');
      debugPrint('textCoverage=$textCoverage');
      debugPrint('====================');

      if (textCoverage < 0.15) {
        debugPrint('GAGAL TEXT COVERAGE');
        debugPrint('textCoverage=$textCoverage');
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

      debugPrint('textCoverage=$textCoverage');
      debugPrint('blurScore=$blurScore');
      for (final line in lines) {
        debugPrint('OCR: ${line.text}');
      }
      final nikLine = _findNikLine(lines);
      debugPrint('nikLine=${nikLine?.text}');
      if (nikLine == null) {
        return KtpCaptureValidation(
          isValid: false,
          message:
              'NIK belum terbaca dengan jelas. Pastikan bagian atas KTP tidak buram dan tidak tertutup pantulan cahaya.',
          blurScore: blurScore,
          textCoverage: textCoverage,
          nikInsideGuide: false,
          processedImagePath: processedImagePath,
        );
      }

      final keywordMatches = _countKtpKeywords(lines);

      debugPrint('keywordMatches=$keywordMatches');

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

  static Future<String> rotateForUpload(String imagePath) async {
    final file = File(imagePath);

    final bytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(bytes);

    if (decodedImage == null) {
      return imagePath;
    }

    final image = img.bakeOrientation(decodedImage);
    debugPrint('BEFORE ROTATE: ${image.width}x${image.height}');

    final img.Image rotated;

    if (image.height > image.width) {
      rotated = img.copyRotate(image, angle: -90);
      debugPrint('ROTATING -90° FOR LANDSCAPE KTP');
    } else {
      rotated = image;
      debugPrint('ALREADY LANDSCAPE');
    }

    debugPrint('AFTER ROTATE: ${rotated.width}x${rotated.height}');

    final uploadPath = imagePath.replaceFirstMapped(
      RegExp(r'(\.jpe?g)\$', caseSensitive: false),
      (match) => match.group(0)!.replaceFirst('.', '_upload.'),
    );

    await File(uploadPath).writeAsBytes(
      img.encodeJpg(rotated, quality: 95),
    );

    debugPrint('UPLOAD PATH: $uploadPath');

    return uploadPath;
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

  static double _estimatePreviewBlurScore(CameraImage cameraImage) {
    if (cameraImage.planes.isEmpty) {
      return 0;
    }

    final bytes = cameraImage.planes.first.bytes;
    final width = cameraImage.width;
    final height = cameraImage.height;
    if (bytes.isEmpty || width < 3 || height < 3) {
      return 0;
    }

    final stride = cameraImage.planes.first.bytesPerRow;
    double total = 0;
    double totalSquared = 0;
    int count = 0;

    for (var y = 1; y < height - 1; y += 4) {
      for (var x = 1; x < width - 1; x += 4) {
        final center = bytes[(y * stride) + x].toDouble();
        final left = bytes[(y * stride) + (x - 1)].toDouble();
        final right = bytes[(y * stride) + (x + 1)].toDouble();
        final top = bytes[((y - 1) * stride) + x].toDouble();
        final bottom = bytes[((y + 1) * stride) + x].toDouble();

        final laplacian = (left + right + top + bottom - (4 * center)).abs();
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

      debugPrint('LINE=${line.text}');
      debugPrint('DIGITS=$digits');

      if (digits.length >= 14) {
        return line;
      }
    }

    return null;
  }
}

class KtpPreviewValidation {
  const KtpPreviewValidation({
    required this.isReady,
    required this.message,
    required this.blurScore,
    required this.recognizedLineCount,
    required this.totalCharacters,
    required this.keywordMatches,
    required this.hasNikCandidate,
  });

  final bool isReady;
  final String message;
  final double blurScore;
  final int recognizedLineCount;
  final int totalCharacters;
  final int keywordMatches;
  final bool hasNikCandidate;
}
