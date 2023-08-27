
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: CustomColor.appBlue
        ),
        title: BigText('About'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SmallText('About'),
              SizedBox(height: 32,),
              BigText('Terms and Condition'),
              SizedBox(height: 16,),
              SmallText('Terms and condition'),
            ],
          ),
        ),
      ),
    );
  }
}