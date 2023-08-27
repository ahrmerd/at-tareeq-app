import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class SecondOnBoarding extends StatelessWidget {
  const SecondOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/onboarding_b.png')),
          SizedBox(
            height: 32,
          ),
          BigText('Upload/Record Lectures'),
          SizedBox(
            height: 16,
          ),
          SmallText(
            'Be it organization, mosque, or lecturer. You can upload lectures for your audience',
            color: CustomColor.appBlue,
          )
        ],
      ),
    );
  }
}
