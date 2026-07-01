import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import '../../../misc/video_cache_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../misc/colors.dart';
import '../../../misc/download_manager.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.urlVideo});

  final String urlVideo;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    final cache = VideoCacheManager.instance;

    final controller = cache.videoControllers[widget.urlVideo];

    if (controller != null) {
      debugPrint("LOAD FROM CACHE : ${widget.urlVideo}");

      _videoController = controller;

      _createChewieController();
    } else {
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    try {
      final cache = VideoCacheManager.instance;

      debugPrint("INITIALIZE VIDEO : ${widget.urlVideo}");

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.urlVideo),
      )..setLooping(false);

      await controller.initialize();

      _videoController = controller;
      cache.videoControllers[widget.urlVideo] = controller;

      if (!mounted) return;

      _createChewieController();
      setState(() {});
    } catch (e, s) {
      _hasError = true;

      debugPrint("VIDEO ERROR : $e");
      debugPrintStack(stackTrace: s);

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    debugPrint("DISPOSE WIDGET : ${widget.urlVideo}");

    _chewieController?.dispose();

    super.dispose();
  }

  void _downloadVideo() {
    DownloadHelper.downloadDoc(context: context, url: widget.urlVideo);
  }

  void _createChewieController() {
    final controller = _videoController;

    if (controller == null) return;
    _chewieController = ChewieController(
      videoPlayerController: controller,
      aspectRatio: controller.value.aspectRatio,
      autoPlay: false,
      looping: false,
      showControls: true,
      allowFullScreen: false,
      showOptions: true,
      additionalOptions: (context) => [
        OptionItem(
          onTap: (ctx) {
            Navigator.pop(ctx);
            _downloadVideo();
          },
          iconData: Icons.download,
          title: 'Download Video',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD VIDEO ${widget.urlVideo}");
    final chewie = _chewieController;
    final controller = _videoController;

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Video tidak dapat dimuat",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.secondaryColor,
        ),
      );
    }

    if (chewie == null) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.secondaryColor,
        ),
      );
    }

    return VisibilityDetector(
      key: ValueKey(widget.urlVideo),
      onVisibilityChanged: (info) {
        if (!mounted) return;

        final controller = _videoController;
        if (controller == null) return;

        if (!controller.value.isInitialized) return;

        if (info.visibleFraction < 0.3) {
          controller.pause();
        }
      },
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Chewie(controller: chewie),
      ),
    );
  }
}
