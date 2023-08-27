import 'package:at_tareeq/app/controllers/interest_lectures_controller.dart';
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

class InterestLecturesPage extends GetView<InterestLecturesController> {
  const InterestLecturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return controller.fetchLectures();
        },
        child: Column(children: [
          SizedBox(
            height: Get.height * 0.25,
            width: Get.width,
            child: MyNetworkImage(
                fit: BoxFit.contain,
                path: controller.interest.thumb,
                useAppRequest: false),
          ),
          Container(
            color: primaryColor,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.interest.name,
                  style: biggerTextStyle.copyWith(color: lightColor),
                ),
                const VerticalSpace(),
                Row(
                  children: [
                    Text('Description: ',
                        style: normalTextStyle.copyWith(color: lightColor, fontWeight: FontWeight.bold)),
                    Text(controller.interest.description ?? '',
                        style: normalTextStyle.copyWith(color: lightColor))
                    // TitleValue(title: 'Description', value: controller.interest.description??'');
                  ],
                )
              ],
            ),
          ),
          const VerticalSpace(),
          
          const VerticalSpace(),
          Expanded(
              child: controller.obx(
                  (state) => VerticalLectureListView(
                        // onAddToFavorite: (lecture) => addToFavorite(lecture),
                        // onAddToPlaylater: (lecture) => addToPlaylater(lecture),
                        label: 'Interest Lecture',
                        lectures: state ?? [],
                      ),
                  onEmpty: const EmptyScreen(),
                  onLoading: const LoadingScreen(),
                  onError: (err) => const ErrorScreen()))
        ]),
      ),
    );
  }
}
