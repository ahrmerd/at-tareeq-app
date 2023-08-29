
import 'package:at_tareeq/app/pages/notifications_page.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
            color: CustomColor.appBlue
        ),
        title: const BigText('Privacy and Location'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            NotificationItem(text: 'Pause location-based recommendations', fontSize: 14,),
            Divider(height: 6,),
            NotificationItem(text: 'Allow GPS usage'),
            Divider(height: 6,),
          ],
        ),
      ),
    );
  }
}