import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControllerWidget extends StatelessWidget {
  const VideoControllerWidget({
    Key? key,
    required this.controller,
    this.onFullScreen,
  }) : super(key: key);

  final VideoPlayerController controller;
  final VoidCallback? onFullScreen;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder:
          (BuildContext context, VideoPlayerValue playerValue, Widget? child) {
        double progress = playerValue.position.inMilliseconds /
            playerValue.duration.inMilliseconds;
        if (playerValue.hasError || playerValue.isInitialized == false) {
          print(
              "player has error:${playerValue.errorDescription}, progress:$progress, init:${playerValue.isInitialized}");
          progress = 0;
        }
        progress = min(1, progress);
        progress = max(progress, 0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              value: progress,
              onChanged: (value) {
                final p = value * playerValue.duration.inMilliseconds;
                controller.seekTo(Duration(milliseconds: p.toInt()));
              },
            ),
            IconButton(
                onPressed: (() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    if (!controller.value.isInitialized ||
                        (controller.value.position ==
                            controller.value.duration)) {
                      controller
                          .initialize()
                          .then((value) => controller.play());
                    } else {
                      controller.play();
                    }
                  }
                }),
                icon: controller.value.isPlaying
                    ? Icon(Icons.pause)
                    : Icon(Icons.play_arrow)),
            IconButton(
                onPressed: (() {
                  if (onFullScreen != null) {
                    onFullScreen!();
                  }
                }),
                icon: Icon(Icons.fullscreen)),
          ],
        );
      },
    );
  }
}
