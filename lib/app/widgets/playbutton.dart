import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class PlayButton extends StatelessWidget {
  final PlayingStatus playingStatus;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onStop;
  const PlayButton(
      {super.key,
      required this.playingStatus,
      this.onPause,
      this.onPlay,
      this.onStop});

  @override
  Widget build(BuildContext context) {
    switch (playingStatus) {
      case PlayingStatus.waiting:
        return GestureDetector(
          onTap: onStop,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: primaryLightColor, shape: BoxShape.circle),
              child: const CircularProgressIndicator()),
        );
      case PlayingStatus.playing:
        return Row(
          children: [
            GestureDetector(
              onTap: onPause,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: primaryLightColor, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.pause_rounded,
                    color: Colors.white,
                  )),
            ),
            GestureDetector(
              onTap: onStop,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: primaryLightColor, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.stop,
                    color: Colors.white,
                  )),
            )
          ],
        );
      // TODO: Handle this case.
      case PlayingStatus.paused:
        return Row(
          children: [
            GestureDetector(
              onTap: onPlay,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: primaryLightColor, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  )),
            ),
            GestureDetector(
              onTap: onStop,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                      color: primaryLightColor, shape: BoxShape.circle),
                  child: const Icon(
                    Icons.stop,
                    color: Colors.white,
                  )),
            )
          ],
        );
      case PlayingStatus.stopped:
        return GestureDetector(
          onTap: onPlay,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: primaryLightColor, shape: BoxShape.circle),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              )),
        );
    }
  }
}

enum PlayingStatus { waiting, playing, paused, stopped }
