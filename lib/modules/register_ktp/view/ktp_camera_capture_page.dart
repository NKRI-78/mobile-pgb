import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_pgb/misc/font_size.dart';
import '../widget/ktp_instruction.dart';

import '../../../misc/colors.dart';
import '../../../misc/text_style.dart';
import '../helper/ktp_capture_analyzer.dart';
import '../model/ktp_capture_validation.dart';

class KtpCameraCapturePage extends StatefulWidget {
  const KtpCameraCapturePage({super.key});

  @override
  State<KtpCameraCapturePage> createState() => _KtpCameraCapturePageState();
}

class _KtpCameraCapturePageState extends State<KtpCameraCapturePage>
    with WidgetsBindingObserver {
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
  bool _showInstruction = true;
  bool get _isLandscape {
    final view = View.of(context);

    return view.physicalSize.width > view.physicalSize.height;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Kembalikan orientasi ke portrait dan landscape saat keluar dari kamera
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openCamera() async {
    // Kunci orientasi ke landscape saat kamera dibuka
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setState(() {
      _showInstruction = false;
    });
    await _setupCamera();
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
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup:
            Platform.isIOS ? ImageFormatGroup.bgra8888 : ImageFormatGroup.nv21,
      );

      await controller.initialize();

      controller.addListener(() {
        debugPrint('ORIENTATION => ${controller.value.deviceOrientation}');
      });

      await Future.delayed(const Duration(milliseconds: 300));

      debugPrint(controller.value.deviceOrientation.toString());

      debugPrint('LOCK = ${controller.value.lockedCaptureOrientation}');
      debugPrint('DEVICE ORIENTATION = ${controller.value.deviceOrientation}');

      debugPrint('PREVIEW SIZE = ${controller.value.previewSize}');

      debugPrint(controller.value.toString());
      await Future.delayed(const Duration(milliseconds: 300));
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
        debugPrint('READY=${analysis.isReady}');
        debugPrint('MSG=${analysis.message}');
        debugPrint('BLUR=${analysis.blurScore}');
        debugPrint('LINES=${analysis.recognizedLineCount}');
        debugPrint('CHARS=${analysis.totalCharacters}');
        debugPrint('KEYWORDS=${analysis.keywordMatches}');
        debugPrint('NIK=${analysis.hasNikCandidate}');
        if (!mounted || _accepted) {
          return;
        }

        if (analysis.isReady) {
          _setStatusMessage('Menstabilkan KTP ${_readyFrameStreak + 1}/3...');
          if (_captureInProgress) {
            return;
          }

          _readyFrameStreak++;

          if (_readyFrameStreak >= 3) {
            _readyFrameStreak = 0;

            _captureInProgress = true;

            try {
              await _captureKtp(image);
            } finally {
              await Future.delayed(const Duration(seconds: 1));

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

  Future<void> _captureKtp(CameraImage image) async {
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

      final String imagePath;
      if (Platform.isIOS && image.format.group == ImageFormatGroup.bgra8888) {
        imagePath = await KtpCaptureAnalyzer.writePreviewFrameToFile(
          cameraImage: image,
        );
      } else {
        final file = await controller.takePicture();
        imagePath = file.path;
      }

      final validation = await KtpCaptureAnalyzer.validate(
        imagePath: imagePath,
        screenSize: screenSize,
      );

      debugPrint('VALID=${validation.isValid}');
      debugPrint('MESSAGE=${validation.message}');

      if (!mounted) return;

      if (!validation.isValid) {
        setState(() {
          _error = validation.message;
          _capturing = false;
          _statusMessage = 'Sesuaikan posisi KTP untuk analisis realtime.';
        });
        await Future.delayed(const Duration(seconds: 2));

        await _startRealtimeAnalysis();
        return;
      }

      _accepted = true;
      Navigator.of(context).pop(validation.processedImagePath ?? imagePath);
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
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _accepted = true;

    _stopRealtimeAnalysis();

    _controller?.dispose();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final guideLayout = KtpGuideLayout.fromSize(size);
    final safeTop = MediaQuery.paddingOf(context).top;

    final headerTop = safeTop + 5;

    final cardRect = guideLayout.cardRect;
    const panelWidth = 160.0;

    if (_showInstruction) {
      return KtpInstructionView(
        isLandscape: _isLandscape,
        onStart: _openCamera,
      );
    }

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
                    fontSize: 14,
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
          Positioned(
            top: headerTop,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  IconButton(
                    onPressed: _capturing
                        ? null
                        : () async {
                            await _stopRealtimeAnalysis();

                            if (mounted) {
                              Navigator.of(context).pop();
                            }
                          },
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
                        fontSize: responsiveFont(context, 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 70),
                ],
              ),
            ),
          ),
          Positioned(
            left: cardRect.right + 8,
            top: cardRect.center.dy - 100,
            child: SizedBox(
              width: panelWidth - 5,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyleNormal.copyWith(
                        color: Colors.white,
                        fontSize: responsiveFont(context, 12),
                      ),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyleNormal.copyWith(
                          color: Colors.white,
                          fontSize: responsiveFont(context, 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            left: cardRect.left - panelWidth - 7,
            top: cardRect.center.dy - 120,
            child: Container(
              width: panelWidth,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Petunjuk :',
                    style: AppTextStyles.textStyleBold.copyWith(
                      color: Colors.white,
                      fontSize: responsiveFont(context, 14),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCheckItem(
                    Icons.crop_free,
                    'Pastikan seluruh KTP terlihat jelas di dalam frame',
                    context,
                  ),
                  _buildCheckItem(
                    Icons.wb_sunny_outlined,
                    'Pastikan pencahayaan cukup dan tidak ada pantulan',
                    context,
                  ),
                  _buildCheckItem(
                    Icons.phone_android,
                    'Pastikan tangan stabil dan tidak goyang',
                    context,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCheckItem(IconData icon, String text, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.whiteColor, size: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.textStyleNormal.copyWith(
              color: AppColors.whiteColor,
              fontSize: responsiveFont(context, 12),
            ),
          ),
        ),
      ],
    ),
  );
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

    debugPrint("CEK PREVIEW SIZE : $previewSize");
    debugPrint("CEK ASPECT : ${controller.value.aspectRatio}");

    debugPrint('SCREEN SIZE = ${MediaQuery.of(context).size}');

    return SizedBox.expand(
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: previewSize.width,
            height: previewSize.height,
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
    final overlayPaint = Paint()..color = Colors.black.withValues(alpha: 0.5);
    final background = Path()..addRect(Offset.zero & size);
    final cardFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;
    final cardPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          guideLayout.cardRect,
          const Radius.circular(16),
        ),
      );

    final dimmed = Path.combine(
      ui.PathOperation.difference,
      background,
      cardPath,
    );
    canvas.drawPath(dimmed, overlayPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.cardRect, const Radius.circular(16)),
      cardFill,
    );

    final cardBorder = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.cardRect, const Radius.circular(16)),
      cardBorder,
    );

    final nikBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final nikFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.nikRect, const Radius.circular(4)),
      nikFill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.nikRect, const Radius.circular(4)),
      nikBorder,
    );

    final sectionBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final sectionFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.headerRect, const Radius.circular(4)),
      sectionFill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.headerRect, const Radius.circular(4)),
      sectionBorder,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.biodataRect,
        const Radius.circular(4),
      ),
      sectionFill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        guideLayout.biodataRect,
        const Radius.circular(4),
      ),
      sectionBorder,
    );

    _drawNikLabel(canvas, guideLayout.nikRect);
    _drawHeaderLabel(canvas, guideLayout.headerRect);
    _drawBiodataLabel(canvas, guideLayout.biodataRect);
    final faceBorder = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final faceFill = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.faceRect, const Radius.circular(4)),
      faceFill,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(guideLayout.faceRect, const Radius.circular(4)),
      faceBorder,
    );

    _drawFaceLabel(canvas, guideLayout.faceRect);
  }

  void _drawFaceLabel(Canvas canvas, Rect rect) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
    );

    final textStyle = ui.TextStyle(color: Colors.white);

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('FOTO WAJAH');

    const textWidth = 120.0;

    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: textWidth));

    canvas.save();

    canvas.translate(rect.center.dx - (textWidth / 2), rect.bottom + 10);

    canvas.drawParagraph(paragraph, Offset.zero);

    canvas.restore();
  }

  void _drawNikLabel(Canvas canvas, Rect rect) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
    );

    final textStyle = ui.TextStyle(color: Colors.white);

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('NIK');

    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: 100));

    canvas.save();

    canvas.translate(rect.left - 70, rect.top + 8);

    canvas.drawParagraph(paragraph, Offset.zero);

    canvas.restore();
  }

  void _drawHeaderLabel(Canvas canvas, Rect rect) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
    );

    final textStyle = ui.TextStyle(color: Colors.white);

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('PROV / KAB');

    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: 100));

    canvas.save();

    canvas.translate(rect.left - 85, rect.top + 10);

    canvas.drawParagraph(paragraph, Offset.zero);

    canvas.restore();
  }

  void _drawBiodataLabel(Canvas canvas, Rect rect) {
    final paragraphStyle = ui.ParagraphStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
      textAlign: TextAlign.center,
    );

    final textStyle = ui.TextStyle(color: Colors.white);

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('BIODATA');

    const textWidth = 120.0;

    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: textWidth));

    canvas.save();

    canvas.translate(rect.center.dx - (textWidth / 2), rect.bottom + 10);

    canvas.drawParagraph(paragraph, Offset.zero);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _KtpGuidePainter oldDelegate) {
    return oldDelegate.guideLayout != guideLayout;
  }
}
