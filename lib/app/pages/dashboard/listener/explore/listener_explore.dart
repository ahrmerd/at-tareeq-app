import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:at_tareeq/app/widgets/my_tab_view.dart';
import 'package:at_tareeq/app/widgets/my_text_input.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerExplore extends StatelessWidget {
  ListenerExplore({super.key});
  ListenerController controller = Get.find<ListenerController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,

          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: myInputDecoration(
                  label: 'search', icon: Icon(Icons.search), borderRadius: 20),
            ),
          ),
          // flexibleSpace: MyTextInput(
          //   controller: controller.searchController,
          //   hintText: 'search',
          //   icon: Icon(Icons.search),
          // ),
        ),
        body: MyTabView(
          tabs: controller.exploreTabs,
        ),
      ),
    );
  }
}
