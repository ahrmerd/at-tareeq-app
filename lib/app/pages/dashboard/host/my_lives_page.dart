import 'package:at_tareeq/app/controllers/my_lives_controller.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLivesPage extends GetView<MyLivesController> {
  const MyLivesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Livestreams'),
      ),
      body: controller.obx((state) {
        return ListView.builder(
            itemCount: state!.length,
            itemBuilder: (_, index) {
              final livestream = state[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    Get.toNamed(Routes.HOSTLIVE,
                        arguments: {'livestream': livestream});
                  },
                  leading: Text(livestream.status.getString()),
                  trailing: Text(dateTimeFormater(livestream.startTime)),
                  title: Text(livestream.title),
                  subtitle: Text(livestream.description),
                ),
              );
            });
      }),
    );
  }
}
