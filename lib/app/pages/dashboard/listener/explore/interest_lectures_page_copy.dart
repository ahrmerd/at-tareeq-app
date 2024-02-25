import 'package:at_tareeq/app/controllers/interest_lectures_controller.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
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
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(children: [
        InterestInfoWidget(interest: controller.interest),
        const VerticalSpace(),
        // const VerticalSpace(),
        Expanded(
            child: RefreshIndicator(
          onRefresh: () {
            return controller.fetchLectures(true);
          },
          child: controller.obx(
              (state) => Obx(() {
                    return VerticalLectureListView(
                      isLoadingMore: controller.isLoadingMore.value,
                      scrollController: controller.scroller,
                      // onAddToFavorite: (lecture) => addToFavorite(lecture),
                      // onAddToPlaylater: (lecture) => addToPlaylater(lecture),
                      label: 'Interest Lecture',
                      lectures: state ?? [],
                    );
                  }),
              onEmpty: EmptyScreen(onRetry: () {
                controller.fetchLectures(true);
              }),
              onLoading: const LoadingScreen(),
              onError: (err) => ErrorScreen(
                    messsage: err,
                    onRetry: () {
                      controller.fetchLectures(true);
                    },
                  )),
        ))
      ]),
    );
  }

//   Widget tt(){
//   return InterestInfoWidget(controller: controller, controller: controller, controller: controller);
// }
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
