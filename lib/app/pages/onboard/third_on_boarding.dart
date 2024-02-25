import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class ThirdOnBoarding extends StatelessWidget {
  const ThirdOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/onboarding_c.png')),
          SizedBox(
            height: 32,
          ),
          BigText('Be Notified of a Lecture'),
          SizedBox(
            height: 16,
          ),
          SmallText(
            'Get notified of a lecture happening in your location.',
            color: CustomColor.appBlue,
          )
        ],
      ),
    );
  }
}
