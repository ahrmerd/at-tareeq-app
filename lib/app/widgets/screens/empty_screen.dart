import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  const EmptyScreen({Key? key, this.message, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber,
            color: CustomColor.appPurple,
            size: 70,
          ),
          const HorizontalSpace(25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message ?? 'You are not lost.We have nothing to show you',
              style: biggerTextStyle.copyWith(color: CustomColor.appPurple),
            ),
          ),
          if (onRetry != null) const HorizontalSpace(),
          if (onRetry != null)
            MyButton(
                color: CustomColor.appPurple,
                onTap: onRetry,
                child: const Text('Retry'))
        ],
      ),
    );
  }
}
