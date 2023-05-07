import 'package:at_tareeq/app/controllers/host_controller.dart';
import 'package:at_tareeq/app/widgets/host_lecture_list.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostLibrary extends GetView<HostController> {
  const HostLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLectures();
    });
    return Scaffold(
      appBar: AppBar(title: Text('Library')),
      body: controller.obx(
        (state) => HostLecturesList(
          lectures: state!,
        ),
        onEmpty: EmptyScreen(),
        onError: (error) => ErrorScreen(),
        onLoading: LoadingScreen(),
      ),
    );
  }
}
