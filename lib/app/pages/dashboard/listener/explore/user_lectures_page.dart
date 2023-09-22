import 'package:at_tareeq/app/controllers/user_lectures_controller.dart';
import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/has_lectures_layout.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLecturesPage extends GetView<UserLecturesController> {
  const UserLecturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return HasLecturesLayout(
        hasInfoWidget: Obx(() => controller.user.value != null
            ? UserInfoWidget(user: controller.user.value!)
            : CircularProgressIndicator()),
        controller: controller);
  }
}

class UserInfoWidget extends StatelessWidget {
  final User user;
  const UserInfoWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: Get.height * 0.25,
            width: Get.width,
            child: MyNetworkImage(
                fit: BoxFit.contain, path: user.thumb, useAppRequest: true)),
        Container(
          color: primaryColor,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.getOrganization(),
                style: biggerTextStyle.copyWith(color: lightColor),
              ),
              Row(
                children: [
                  Text('Uploaders Name: ',
                      style: normalTextStyle.copyWith(
                          color: lightColor, fontWeight: FontWeight.bold)),
                  Text(user.name,
                      style: normalTextStyle.copyWith(color: lightColor))
                  // TitleValue(title: 'Description', value: controller.interest.description??'');
                ],
              ),
              const VerticalSpace(),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: lightColor,
                  ),
                  Text(user.location ?? 'Unknown Location',
                      style: bigTextStyle.copyWith(color: lightColor))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
