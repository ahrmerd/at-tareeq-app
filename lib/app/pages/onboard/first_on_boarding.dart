import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';

import 'package:flutter/material.dart';

class FirstOnBoarding extends StatelessWidget {
  const FirstOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/onboarding_a.png')),
          SizedBox(
            height: 32,
          ),
          BigText('Listen to Lectures'),
          SizedBox(
            height: 16,
          ),
          SmallText(
            'Have access to lectures from your favourite lecturers, mosques or organizations around you',
            color: CustomColor.appBlue,
          ),
        ],
      ),
    );
  }
}
