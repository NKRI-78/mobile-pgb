import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../misc/colors.dart';
import '../../../misc/download_manager.dart';
import '../loading_page.dart';

class DetailVideoPlayer extends StatefulWidget {
  const DetailVideoPlayer({super.key, required this.urlVideo});

  final String urlVideo;

  @override
  State<DetailVideoPlayer> createState() => _DetailVideoPlayerState();
}

class _DetailVideoPlayerState extends State<DetailVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (widget.urlVideo.startsWith('/')) {
      _videoController = VideoPlayerController.file(File(widget.urlVideo));
    } else {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.urlVideo));
    }

    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: _videoController.value.aspectRatio,
      autoPlay: true,
      looping: false,
      showControls: true,
      allowFullScreen: false,
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
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text("Gagal memuat video: $errorMessage",
              style: const TextStyle(color: Colors.white)),
        );
      },
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _downloadVideo() {
    DownloadHelper.downloadDoc(context: context, url: widget.urlVideo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VisibilityDetector(
        key: ObjectKey(_videoController),
        onVisibilityChanged: (VisibilityInfo info) {
          var visiblePercentage = info.visibleFraction * 100;
          debugPrint('Widget ${info.key} is $visiblePercentage% visible');
          if (info.visibleFraction == 0 && mounted) {
            _videoController.pause();
          }
        },
        child: Center(
          child: _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                )
              : CustomLoadingPage(color: AppColors.whiteColor),
        ),
      ),
    );
  }
}
