import 'package:at_tareeq/app/controllers/host_live_controller.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class HostLiveControlsWidget extends StatelessWidget {
  const HostLiveControlsWidget({
    super.key,
    required this.controller,
  });

  final HostLiveController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarGlow(
            glowColor: Colors.redAccent,
            endRadius: controller.isLive.value ? 30 : 20,
            child: CircleAvatar(
              backgroundColor: controller.isLive.value
                  ? Colors.red
                  : Colors.grey,
              child: IconButton(
                icon: Icon(
                  Icons.mic_none_rounded,
                  color: controller.isLive.value
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () {
                  controller.startBroadcast();
                },
              ),
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: IconButton(
                  isSelected: controller.isMuted.value,
                  selectedIcon: const Icon(
                    Icons.volume_off_outlined,
                    color: Colors.black,
                  ),
                  icon: const Icon(
                    Icons.volume_up_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    controller.isMuted.value
                        ? controller.unmuteBroadcast()
                        : controller.muteBroadcast();
                  },
                ),
              ),
              const HorizontalSpace(),
              MyButton(
                onTap: () {
                  controller.stopBroadcast();
                },
                child: const Text('End Lecture'),
              ),
              const HorizontalSpace(),
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}