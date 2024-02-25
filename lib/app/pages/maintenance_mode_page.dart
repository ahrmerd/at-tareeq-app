import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaintenanceModePage extends StatefulWidget {
  const MaintenanceModePage({super.key, this.url});
  final String? url;

  @override
  State<MaintenanceModePage> createState() => _MaintenanceModePageState();
}

class _MaintenanceModePageState extends State<MaintenanceModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icon.png',
            width: 100,
            height: 100,
          ),
          // const Icon(
          //   Icons.warning_amber,
          //   color: CustomColor.appPurple,
          //   size: 70,
          // ),
          const VerticalSpace(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'There is an Ongoing maintenance Please return after some time',
              style: bigTextStyle.copyWith(color: CustomColor.appPurple),
            ),
          ),
          const VerticalSpace(),
          MyButton(
              color: CustomColor.appPurple,
              onTap: () {
                Get.offNamed(Pages.initial);
              },
              child: const BigText('Recheck', fontSize: 20,)),
          const VerticalSpace(),
          MyButton(
              color: CustomColor.appPurple,
              onTap: () {
                Get.back();
              },
              child: const BigText('Quit', fontSize: 20,))
        ],
      ),
    ));
  }
}
