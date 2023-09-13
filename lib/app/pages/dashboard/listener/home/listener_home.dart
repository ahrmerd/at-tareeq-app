import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/my_tab_view.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerHome extends StatelessWidget {
  ListenerHome({super.key});
  final ListenerController controller = Get.find<ListenerController>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.homeTabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: false,
          title: BigText(
            "Hi ${SharedPreferencesHelper.getName()}",
            // style: biggerTextStyle,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.LIVES);
              },
              child: const Row(
                children: [
                  Icon(Icons.online_prediction_outlined),
                  SizedBox(
                    width: 9,
                  ),
                  Text('Live Program')
                ],
              ),
            )
          ],
        ),
        body: MyTabView(
          tabs: controller.homeTabs,
        ),
      ),
    );
  }
}
