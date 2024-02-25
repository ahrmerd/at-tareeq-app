import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String? messsage;
  const SuccessScreen({super.key, this.messsage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.done_all,
            color: Colors.blue,
            size: 60,
          ),
          const HorizontalSpace(25),
          Text(
            messsage ?? 'The operation was successfull',
            style: const TextStyle(
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
