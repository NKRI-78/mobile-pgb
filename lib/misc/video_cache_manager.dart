import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoCacheManager {
  VideoCacheManager._();

  static final VideoCacheManager instance = VideoCacheManager._();

  final Map<String, VideoPlayerController> videoControllers = {};

  void clear() {
    for (final controller in videoControllers.values) {
      controller.dispose();
    }

    videoControllers.clear();
  }

  void pauseAll() {
    debugPrint("===== PAUSE ALL =====");

    for (final entry in videoControllers.entries) {
      debugPrint("PAUSE : ${entry.key}");
      entry.value.pause();
    }
  }
}
