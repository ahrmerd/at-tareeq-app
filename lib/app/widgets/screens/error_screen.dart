import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? messsage;
  final String? retryMessage;
  final VoidCallback? onRetry;
  const ErrorScreen({super.key, this.messsage, this.onRetry, this.retryMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber,
            color: Colors.red,
            size: 70,
          ),
          const HorizontalSpace(25),
          Text(
            messsage ?? 'An Error Occurred',
            style: biggerTextStyle.copyWith(color: Colors.red),
          ),
          if (onRetry != null) const HorizontalSpace(),
          if (onRetry != null)
            MyButton(danger: true, onTap: onRetry, child: Text(retryMessage??'Retry'))
        ],
      ),
    );
  }
}
