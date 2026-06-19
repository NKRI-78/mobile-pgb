import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      showOptions: false,
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
      // Use OrientationBuilder to adapt UI when device rotates
      body: OrientationBuilder(builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        // Optional: hide system overlays in landscape for immersive fullscreen
        if (isLandscape) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }

        return VisibilityDetector(
          key: ObjectKey(_videoController),
          onVisibilityChanged: (VisibilityInfo info) {
            var visiblePercentage = info.visibleFraction * 100;
            debugPrint('Widget ${info.key} is $visiblePercentage% visible');
            if (info.visibleFraction == 0 && mounted) {
              _videoController.pause();
            }
          },
          child: Stack(
            children: [
              // Center the video player
              Center(
                child: _chewieController != null &&
                        _chewieController!
                            .videoPlayerController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: Chewie(controller: _chewieController!),
                      )
                    : CustomLoadingPage(color: AppColors.whiteColor),
              ),

              // Top overlay row containing back button and menu (three-dots)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back button
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: () {
                            // restore overlays before popping
                            SystemChrome.setEnabledSystemUIMode(
                                SystemUiMode.edgeToEdge);
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      // Three-dots menu (custom, aligned with back button)
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: PopupMenuButton<int>(
                          color: Colors.black87,
                          icon:
                              const Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            if (value == 1) _downloadVideo();
                          },
                          itemBuilder: (ctx) => [
                            const PopupMenuItem(
                                value: 1,
                                child: Text('Download Video',
                                    style: TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
