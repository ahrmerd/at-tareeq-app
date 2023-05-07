import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String? messsage;
  final VoidCallback? onReturn;
  const ErrorScreen({Key? key, this.messsage, this.onReturn}) : super(key: key);

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
          if (onReturn != null) const HorizontalSpace(),
          if (onReturn != null)
            MyButton(danger: true, onTap: onReturn, child: const Text('Return'))
        ],
      ),
    );
  }
}
