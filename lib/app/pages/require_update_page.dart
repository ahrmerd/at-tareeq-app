import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RequireUpdatePage extends StatefulWidget {
  const RequireUpdatePage({super.key, this.url});
  final String? url;

  @override
  State<RequireUpdatePage> createState() => _RequireUpdatePageState();
}

class _RequireUpdatePageState extends State<RequireUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon.png', width: 100, height: 100,),
          // const Icon(
          //   Icons.warning_amber,
          //   color: CustomColor.appPurple,
          //   size: 70,
          // ),
          const VerticalSpace(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'You are required to update your app',
              style: bigTextStyle.copyWith(color: CustomColor.appPurple),
            ),
          ),
          const VerticalSpace(),
            MyButton(
                color: CustomColor.appPurple,
                onTap: (){
                  _launchUrl();
                },
                child: const BigText('Continue',fontSize: 20,))
        ],
      ),
    )
    );
  }

  Future<void> _launchUrl() async {
  if (!await launchUrl(Uri.parse(widget.url??defaultUpdateUrl))) {
    throw Exception('Could not launch url');
  }
}
}