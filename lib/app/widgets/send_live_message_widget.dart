import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:flutter/material.dart';

class SendMessageWidget extends StatelessWidget {
  const SendMessageWidget({
    super.key, required this.onSubmit, required this.messageFieldControlller,
  });

  final void Function(String val) onSubmit;
  final TextEditingController messageFieldControlller;
  // final HostLiveController controller;
  // final HostLiveController controller;
  // final HostLiveController controller;
  // final HostLiveController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          // constraints: BoxConstraints.loose(Size(Get.width - 70, 200)),
          // width: Get.width - 170,
          child: TextField(
            controller: messageFieldControlller,
            onSubmitted: (val) {
              onSubmit(val);
              // controller.sendMessage(val);
            },
            decoration: myInputDecoration2(label: "Message"),
          ),
        ),
        const HorizontalSpace(),
        MyButton(
          child: const Icon(Icons.send),
          onTap: () {
            onSubmit(messageFieldControlller.text);
            // controller
                // .sendMessage(controller.);
          },
        )
      ],
    );
  }
}