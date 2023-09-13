import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/live_messages.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class LiveMessagesWidget extends StatelessWidget {
  const LiveMessagesWidget({super.key, required this.messagesProcessingStatus, required this.messageScrollController, required this.messages, this.onRefresh, this.hostUserId,});
  final ProcessingStatus messagesProcessingStatus;
  final ScrollController messageScrollController;
  final VoidCallback? onRefresh;
  final int? hostUserId;
  final List<LiveMessage> messages;

  @override
  Widget build(BuildContext context) {
    switch (messagesProcessingStatus) {
        case ProcessingStatus.success:
          return ListView.builder(
              // primary: false,
              // shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              controller: messageScrollController,
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              itemBuilder: (_, i) {
                final message = messages[i];
                final bool isSentByMe =
                    SharedPreferencesHelper.getUserId() == message.user.id;
                                final bool isHost = hostUserId == message.user.id;
                return Container(
                  // constraints: BoxConstraints(
                  // maxWidth: MediaQuery.of(context).size.width * 0.7,
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.user.name+ (isHost?'(Lecture Host)':''),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: isHost ? FontWeight.w500 :  FontWeight.w300),
                      ),
                      // separa
                      Text(
                        message.message,
                        style: TextStyle(
                            color: isSentByMe? primaryLightColor:  Colors.white, fontSize: 16),
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
                          Divider(thickness: 1,
                              color: Colors.grey.shade500, endIndent: 100,)
                    ],
                  ),
                );
              });
        case ProcessingStatus.loading:
        case ProcessingStatus.initial:
          return const ColorLoader();
          // return const CircularProgressIndicator();
        case ProcessingStatus.error:
          return ErrorScreen(onRetry: onRefresh, messsage: "Couldn't fetch messages",);
      }
  }
}