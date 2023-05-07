import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
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
            color: Colors.orange,
            size: 70,
          ),
          const HorizontalSpace(25),
          Text(
            message ?? 'There are no resource available',
            style: biggerTextStyle.copyWith(color: Colors.orange),
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
