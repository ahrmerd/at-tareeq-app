import 'package:at_tareeq/app/controllers/interest_lectures_controller.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/has_lectures_layout.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterestLecturesPage extends GetView<InterestLecturesController> {
  const InterestLecturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HasLecturesLayout(
        hasInfoWidget: InterestInfoWidget(interest: controller.interest),
        controller: controller);
  }
}

class InterestInfoWidget extends StatelessWidget {
  final SectionOrInterest interest;
  const InterestInfoWidget({
    super.key,
    required this.interest,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.25,
          width: Get.width,
          child: MyNetworkImage(
              fit: BoxFit.contain, path: interest.thumb, useAppRequest: false),
        ),
        Container(
          color: primaryColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                interest.name,
                style: biggerTextStyle.copyWith(color: lightColor),
              ),
              const VerticalSpace(),
              Row(
                children: [
                  Text('Description: ',
                      style: normalTextStyle.copyWith(
                          color: lightColor, fontWeight: FontWeight.bold)),
                  Text(interest.description ?? '',
                      style: normalTextStyle.copyWith(color: lightColor))
                  // TitleValue(title: 'Description', value: controller.interest.description??'');
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
