import 'package:at_tareeq/app/controllers/add_live_controller.dart';
import 'package:at_tareeq/app/widgets/lecture_detail_form.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddLivestream extends GetView<AddLiveController> {
  const AddLivestream({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpace(15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Details',
                    style: biggestTextStyle,
                  ),
                  Text(
                    'Fill in the details about this stream',
                    style: bigTextStyle,
                  ),
                ],
              ),
            ),
            const VerticalSpace(15),
            Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Scheduled StartTime:'),
                    const HorizontalSpace(),
                    Text(
                      formatDateTime(controller.scheduledTime.value),
                      style: bigTextStyle,
                    ),
                    const HorizontalSpace(),
                    MyButton(
                      child:
                          const Text('Select scheduled time to start stream'),
                      onTap: () async {
                        final date = (await showDatePicker(
                                context: context,
                                initialDate: controller.scheduledTime.value,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 4)))) ??
                            DateTime.now();
                        final time = (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(date))) ??
                            TimeOfDay.now();
                        // print(time.hour);
                        // print(time.minute);
                        controller.scheduledTime.value =
                            date.copyWith(hour: time.hour, minute: time.minute);
                        // print(controller.scheduledTime.value.hour);
                      },
                    ),
                  ],
                ),
              );
            }),
            const VerticalSpace(15),
            Expanded(
              child: controller.obx(
                (state) {
                  return LectureDetailsForm(
                    label: 'Start Live',
                    onSubmit: (title, sectionId, description) {
                      controller.submitForm(title, sectionId, description);
                    },
                    sections: state!,
                  );
                },
                onLoading: const LoadingScreen(),
                onError: (err) => ErrorScreen(
                  onReturn: controller.refetchSections,
                ),
                onEmpty: EmptyScreen(
                    onReturn: controller.refetchSections,
                    message:
                        'There are no interest, you wont be able to add a lecture please contact admin to add some interest'),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
