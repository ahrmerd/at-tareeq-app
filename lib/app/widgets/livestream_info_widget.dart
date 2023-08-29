
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/widgets/livestream_details_widget.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LiveStreamInfoWidget extends StatelessWidget {
  const LiveStreamInfoWidget({
    super.key,
    required this.processingStatus,
    required this.thumbPath,
    required this.lecturer,
    required this.title,
  });

  final ProcessingStatus processingStatus;
  final String thumbPath;
  final String lecturer;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LiveStreamThumb(
            processingStatus: processingStatus, thumbPath: thumbPath),
        const VerticalSpace(16),
        LiveStreamDetails(
          lecturer: lecturer,
          title: title,
        ),
      ],
    );
  }
}

class LiveStreamThumb extends StatelessWidget {
  const LiveStreamThumb({
    super.key,
    required this.processingStatus,
    required this.thumbPath,
    // required this.controller,
    // required this.controller,
  });

  final ProcessingStatus processingStatus;
  final String thumbPath;
  // final HostLiveController controller;

  @override
  Widget build(BuildContext context) {
    // return Obx(() {
    switch (processingStatus) {
      case ProcessingStatus.initial:
        return const SizedBox(
          height: 200,
          child: Column(
            children: [
              ColorLoader(),
            ],
          ),
        );
      case ProcessingStatus.success:
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: MyNetworkImage(
            path: thumbPath,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      case ProcessingStatus.error:
        return const ErrorScreen(
          messsage: "Unable to initalize livestream",
        );
      case ProcessingStatus.loading:
        return const ColorLoader();
    }
    // });
  }
}