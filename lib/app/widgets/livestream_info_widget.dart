import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/extentions/string_extensions.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamInfoWidget extends StatelessWidget {
  const LiveStreamInfoWidget({
    super.key,
    required this.thumbPath,
    required this.lecturer,
    required this.title,
    required this.showThumb,
  });

  final String thumbPath;
  final String lecturer;
  final String title;
  final bool showThumb;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: DefaultTextStyle(
        style: TextStyle(color: Colors.grey.shade500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const VerticalSpace(),
            Row(
              children: [
                const Text(
                  "Title:  ",
                  style: TextStyle(fontSize: 16),
                ),
                BigText(
                  title.toCapitalize,
                  fontSize: 16,
                  color: lightColor,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Lecturer:  ",
                  style: TextStyle(fontSize: 16),
                ),
                SmallText(
                  lecturer.toCapitalize,
                  fontSize: 14,
                  color: lightColor,
                ),
              ],
            ),
            const VerticalSpace(7),
            // BigText(
            //   title,
            //   fontSize: 16,
            //   color: lightColor,
            // ),
            // const SizedBox(
            //   height: 6,
            // ),
            // SmallText(
            //   lecturer,
            //   fontSize: 15,
            //   color: lightColor,
            // ),
            if (showThumb) ...[
              const VerticalSpace(30),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: MyNetworkImage(
                    path: thumbPath,
                    height: 200,
                    width: Get.width * 0.85,
                    // width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
