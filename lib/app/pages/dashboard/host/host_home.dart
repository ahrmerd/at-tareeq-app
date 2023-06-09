import 'package:at_tareeq/app/controllers/host_controller.dart';
import 'package:at_tareeq/app/widgets/host_lecture_list.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HostHome extends GetView<HostController> {
  const HostHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLectures();
    });
    return Column(
      children: [
        Obx(() {
          return AnimatedContainer(
            // color: controller.isOpen.value ? Colors.red : Colors.blue,
            height: controller.isExpanded.value ? 200 : Get.height / 2,
            duration: controller.animationDuration,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: GridView(
                padding: EdgeInsets.all(50),
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 70,
                  mainAxisSpacing: 40,
                  mainAxisExtent: Get.height / 6,
                ),
                // alignment: WrapAlignment.spaceEvenly,
                // runAlignment: WrapAlignment.spaceEvenly,
                children: [
                  ...List.generate(controller.hostActions.length, (index) {
                    final item = controller.hostActions[index];
                    return GestureDetector(
                      onTap: item.onTap,
                      child: Container(
                        // height: 90,
                        // width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 20,
                                  spreadRadius: .2)
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            item.icon,
                            const SizedBox(
                              height: 20,
                            ),
                            Text(item.title)
                          ],
                        ),
                      ),
                    );
                  }),
                  // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: []),
                  // Row(children: []),
                ]),
          );
        }),
        VerticalSpace(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Lecture',
                style: biggerTextStyle,
              ),
              Obx(() {
                return MyButton(
                    onTap: () {
                      controller.openMore();
                    },
                    child: AnimatedCrossFade(
                        firstChild: Text('Expand'),
                        secondChild: Text('Collapse'),
                        crossFadeState: !controller.isExpanded.value
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: controller.animationDuration));
              }),
            ],
          ),
        ),
        Expanded(
          child: controller.obx(
            (state) => HostLecturesList(
              lectures: state!,
            ),
            onEmpty: EmptyScreen(),
            onError: (error) => ErrorScreen(),
            onLoading: LoadingScreen(),
          ),
        ),
      ],
    );
  }
}
