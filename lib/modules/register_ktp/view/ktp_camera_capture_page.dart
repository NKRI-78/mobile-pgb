import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../helper/ktp_capture_analyzer.dart';
import '../model/ktp_capture_validation.dart';

class KtpCameraCapturePage extends StatefulWidget {
  const KtpCameraCapturePage({super.key});

  @override
  State<KtpCameraCapturePage> createState() => _KtpCameraCapturePageState();
}

class _KtpCameraCapturePageState extends State<KtpCameraCapturePage> {
  CameraController? _controller;
  bool _initializing = true;
  bool _capturing = false;
  bool _accepted = false;
  String? _error;
  String _statusMessage = 'Mempersiapkan analisis realtime...';
  bool _analyzingFrame = false;
  bool _captureInProgress = false;
  DateTime? _lastAnalyzedAt;
  int _readyFrameStreak = 0;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.where(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      if (backCamera.isEmpty) {
        setState(() {
          _error = 'Kamera belakang tidak tersedia di perangkat ini.';
          _initializing = false;
        });
        return;
      }

      final controller = CameraController(
        backCamera.first,
        ResolutionPreset.veryHigh,
        enableAudio: false,
        imageFormatGroup:
            Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _initializing = false;
      });
      await _startRealtimeAnalysis();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Kamera gagal dibuka. Coba tutup lalu buka kembali.';
        _initializing = false;
      });
    }
  }

  Future<void> _startRealtimeAnalysis() async {
    final controller = _controller;

    if (controller == null || controller.value.isStreamingImages) {
      return;
    }

    await controller.startImageStream((image) async {
      if (!mounted ||
          _capturing ||
          _accepted ||
          _initializing ||
          _analyzingFrame) {
        return;
      }

      final now = DateTime.now();
      if (_lastAnalyzedAt != null &&
          now.difference(_lastAnalyzedAt!) <
              const Duration(milliseconds: 300)) {
        return;
      }
      _lastAnalyzedAt = now;
      _analyzingFrame = true;

      try {
        final analysis = await KtpCaptureAnalyzer.validatePreviewFrame(
          cameraImage: image,
        );
        print('READY=${analysis.isReady}');
        print('MSG=${analysis.message}');
        print('BLUR=${analysis.blurScore}');
        print('LINES=${analysis.recognizedLineCount}');
        print('CHARS=${analysis.totalCharacters}');
        print('KEYWORDS=${analysis.keywordMatches}');
        print('NIK=${analysis.hasNikCandidate}');
        if (!mounted || _accepted) {
          return;
        }

        if (analysis.isReady) {
          _setStatusMessage(
            'Menstabilkan KTP ${_readyFrameStreak + 1}/6...',
          );
          if (_captureInProgress) {
            return;
          }

          _readyFrameStreak++;

          if (_readyFrameStreak >= 6) {
            _readyFrameStreak = 0;

            _captureInProgress = true;

            try {
              await _captureKtp();
            } finally {
              await Future.delayed(
                const Duration(seconds: 5),
              );

              _captureInProgress = false;
            }
          }

          return;
        }

        _readyFrameStreak = 0;
        _setStatusMessage(analysis.message);
      } finally {
        _analyzingFrame = false;
      }
    });
  }

  Future<void> _stopRealtimeAnalysis() async {
    final controller = _controller;
    if (controller == null || !controller.value.isStreamingImages) {
      return;
    }

    await controller.stopImageStream();
    _analyzingFrame = false;
  }

  Future<void> _captureKtp() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _capturing) {
      return;
    }

    setState(() {
      _capturing = true;
      _error = null;
      _statusMessage = 'Mengambil foto KTP...';
    });

    try {
      final screenSize = MediaQuery.of(context).size;
      await _stopRealtimeAnalysis();
      final file = await controller.takePicture();
      final validation = await KtpCaptureAnalyzer.validate(
        imagePath: file.path,
        screenSize: screenSize,
      );

      print('VALID=${validation.isValid}');
      print('MESSAGE=${validation.message}');

      if (!mounted) return;

      if (!validation.isValid) {
        setState(() {
          _error = validation.message;
          _capturing = false;
          _statusMessage = 'Sesuaikan posisi KTP untuk analisis realtime.';
        });
        await Future.delayed(
          const Duration(seconds: 2),
        );

        await _startRealtimeAnalysis();
        return;
      }

      _accepted = true;
      Navigator.of(context).pop(validation.processedImagePath ?? file.path);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Foto KTP gagal diproses. Silakan coba lagi.';
        _capturing = false;
        _statusMessage = 'Analisis realtime aktif. Coba stabilkan KTP lagi.';
      });
      await _startRealtimeAnalysis();
    }
  }

  void _setStatusMessage(String message) {
    if (!mounted || _statusMessage == message) {
      return;
    }

    setState(() {
      _statusMessage = message;
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final guideLayout = KtpGuideLayout.fromSize(size);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            _FullscreenCameraPreview(controller: _controller!)
          else if (_initializing)
            const Center(
              child: CircularProgressIndicator(color: AppColors.whiteColor),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _error ?? 'Kamera tidak tersedia.',
                  style: AppTextStyles.textStyleNormal.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (_controller != null && _controller!.value.isInitialized)
            CustomPaint(
              painter: _KtpGuidePainter(guideLayout: guideLayout),
              child: const SizedBox.expand(),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: _capturing
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Ambil Foto KTP Otomatis',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyleBold.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Posisikan seluruh KTP di dalam frame. Preview akan dianalisis secara realtime dan foto diambil saat frame live sudah cukup jelas.',
                    style: AppTextStyles.textStyleNormal.copyWith(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Text(
                      _statusMessage,
                      style: AppTextStyles.textStyleNormal.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Spacer(),
                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.redColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        _error!,
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (_error != null) const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullscreenCameraPreview extends StatelessWidget {
  const _FullscreenCameraPreview({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return const SizedBox.expand();
    }

    return SizedBox.expand(
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.height,
            height: previewSize.width,
            child: CameraPreview(controller),
          ),
        ),
      ),
    );
  }
}

class _KtpGuidePainter extends CustomPainter {
  const _KtpGuidePainter({required this.guideLayout});

  final KtpGuideLayout guideLayout;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.45);
    final background = Path()..addRect(Offset.zero & size);
    final cardFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    final cardPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          guideLayout.cardRect,
          const Radius.circular(18),
        ),
      );

    final dimmed = Path.combine(
      ui.PathOperation.difference,
      background,
      cardPath,
    );
    canvas.drawPath(dimmed, overlayPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.cardRect,
        const Radius.circular(18),
      ),
      cardFill,
    );

    final cardBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.cardRect,
        const Radius.circular(18),
      ),
      cardBorder,
    );

    final nikBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final nikFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.nikRect,
        const Radius.circular(12),
      ),
      nikFill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.nikRect,
        const Radius.circular(12),
      ),
      nikBorder,
    );

    _drawNikLabel(canvas, guideLayout.nikRect);
    final faceBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final faceFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.faceRect,
        const Radius.circular(12),
      ),
      faceFill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.faceRect,
        const Radius.circular(12),
      ),
      faceBorder,
    );

    _drawFaceLabel(canvas, guideLayout.faceRect);
  }

  void _drawFaceLabel(Canvas canvas, Rect rect) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
    );

    final textStyle = ui.TextStyle(
      color: Colors.white,
    );

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('FOTO WAJAH');

    final paragraph = builder.build()
      ..layout(
        const ui.ParagraphConstraints(
          width: 120,
        ),
      );

    canvas.save();

    canvas.translate(
      rect.right + 14,
      rect.top,
    );

    canvas.rotate(1.5708);

    canvas.drawParagraph(
      paragraph,
      Offset.zero,
    );

    canvas.restore();
  }

  void _drawNikLabel(Canvas canvas, Rect rect) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
    );

    final textStyle = ui.TextStyle(
      color: Colors.white,
    );

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('AREA NIK');

    final paragraph = builder.build()
      ..layout(
        const ui.ParagraphConstraints(
          width: 100,
        ),
      );

    canvas.save();

    canvas.translate(
      rect.right + 14,
      rect.top,
    );

    canvas.rotate(1.5708);

    canvas.drawParagraph(
      paragraph,
      Offset.zero,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KtpGuidePainter oldDelegate) {
    return oldDelegate.guideLayout != guideLayout;
  }
}
