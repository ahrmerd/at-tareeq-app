import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/live_messages.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class LiveMessagesWidget extends StatelessWidget {
  const LiveMessagesWidget({super.key, required this.messagesProcessingStatus, this.messageScrollController, required this.messages,});
  final ProcessingStatus messagesProcessingStatus;
  final ScrollController? messageScrollController;
  final List<LiveMessage> messages;

  @override
  Widget build(BuildContext context) {
    switch (messagesProcessingStatus) {
        case ProcessingStatus.success:
          return ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: messageScrollController,
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final message = messages[i];
                final bool isSentByMe =
                    SharedPreferencesHelper.getUserId() == message.user.id;
                return ChatBubble(
                  clipper: ChatBubbleClipper3(
                      type: isSentByMe
                          ? BubbleType.sendBubble
                          : BubbleType.receiverBubble),
                  alignment:
                      isSentByMe ? Alignment.topRight : Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20),
                  backGroundColor: primaryColor,
                  child: Container(
                    // constraints: BoxConstraints(
                    // maxWidth: MediaQuery.of(context).size.width * 0.7,
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.user.name,
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                        // separa
                        Text(
                          message.message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                        message.isSending
                            ? const Icon(
                                Icons.cached,
                                size: 10,
                                color: Colors.grey,
                              )
                            : Text(
                                formatDateTime(message.createdAt),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300),
                              ),
                      ],
                    ),
                  ),
                );
              });
        case ProcessingStatus.initial:
          return const CircularProgressIndicator();
        case ProcessingStatus.error:
          return const ErrorScreen();
        case ProcessingStatus.loading:
          return const CircularProgressIndicator();
      }
  }
}