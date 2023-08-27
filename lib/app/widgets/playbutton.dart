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
  
final decorationColor = CustomColor.appPurple;
final boxShape = BoxShape.circle;
final iconColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    switch (playingStatus) {
      case PlayingStatus.waiting:
        return GestureDetector(
          onTap: onStop,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: decorationColor, shape: boxShape),
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
                  decoration: BoxDecoration(
                      color: decorationColor, shape: boxShape),
                  child: Icon(
                    Icons.pause_rounded,
                    color: iconColor,
                  )),
            ),
            GestureDetector(
              onTap: onStop,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: decorationColor, shape: boxShape),
                  child: Icon(
                    Icons.stop,
                    color: iconColor,
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
                  decoration: BoxDecoration(
                      color: decorationColor, shape: boxShape),
                  child: Icon(
                    Icons.play_arrow,
                    color: iconColor,
                  )),
            ),
            GestureDetector(
              onTap: onStop,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: decorationColor, shape: boxShape),
                  child: Icon(
                    Icons.stop,
                    color: iconColor,
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
              decoration: BoxDecoration(
                  color: decorationColor, shape: boxShape),
              child: Icon(
                Icons.play_arrow,
                color: iconColor,
              )),
        );
    }
  }
}

enum PlayingStatus { waiting, playing, paused, stopped }
