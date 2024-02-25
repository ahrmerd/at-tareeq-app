import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColorLoader(
            radius: 50,
            dotRadius: 10,
          ),
          HorizontalSpace(25),
          Text(
            'We are Working, Please wait a moment...',
            style: TextStyle(
              color: primaryDarkColor,
            ),
          )
        ],
      ),
    );
  }
}
