import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/my_tab_view.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class ListenerHome extends StatelessWidget {
  ListenerHome({super.key});
  ListenerController controller = Get.find<ListenerController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          "Hi ${SharedPreferencesHelper.getName()}",
          style: biggerTextStyle,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.LIVES);
            },
            child: Row(
              children: const [
                Icon(Icons.broadcast_on_personal),
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
    );
  }
}
