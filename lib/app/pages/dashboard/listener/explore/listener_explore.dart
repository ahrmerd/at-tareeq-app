import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:at_tareeq/app/widgets/my_tab_view.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerExplore extends StatelessWidget {
  ListenerExplore({super.key});
  final ListenerController controller = Get.find<ListenerController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,

          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomSearch(),
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


class CustomSearch extends StatelessWidget {
  const CustomSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(child: Column(
      children: [
        TextFormField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Search for lectures here', hintStyle: const TextStyle(color: CustomColor.appBlue),
            suffixIcon: const Icon(Icons.search_outlined, color: CustomColor.appBlue,),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: CustomColor.appBlue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: const BorderSide(
                  color: CustomColor.appBlue,
                )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: CustomColor.appBlue,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}