import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String? message;
  final VoidCallback? onReturn;
  const EmptyScreen({Key? key, this.message, this.onReturn}) : super(key: key);

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
          if (onReturn != null) const HorizontalSpace(),
          if (onReturn != null)
            MyButton(
                color: Colors.orangeAccent,
                onTap: onReturn,
                child: const Text('Return'))
        ],
      ),
    );
  }
}
