import 'package:at_tareeq/app/data/models/my_list_item.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/about_page.dart';
import 'package:at_tareeq/app/pages/notifications_page.dart';
import 'package:at_tareeq/app/pages/privacy_page.dart';
import 'package:at_tareeq/app/widgets/my_iist_tile.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/upload_profile_picture_widget.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerProfile extends StatefulWidget {
  const ListenerProfile({Key? key}) : super(key: key);

  @override
  State<ListenerProfile> createState() => _ListenerProfileState();
}

class _ListenerProfileState extends State<ListenerProfile> {
  final libraryItems = <MyListItem>[
    MyListItem(const Icon(Icons.notifications_none_rounded), 'Notifications',
        () {
      Get.to(() => const NotificationsPage());
    }),
    MyListItem(const Icon(Icons.privacy_tip_rounded), 'Privacy and Location',
        () {
      Get.to(() => const PrivacyPage());
    }),
    MyListItem(const Icon(Icons.info_outline), 'About', () {
      Get.to(() => const AboutPage());
    }),
    MyListItem(const Icon(Icons.exit_to_app), 'Log Out', () {
      Dependancies.authService().logout();
    }),
    // MyListItem(const Icon(Icons.download), 'Downloads', () {}),
  ];

  var path = 'profile-image';

  final name = SharedPreferencesHelper.getName();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          // title: Text(
          //   'Profile',
          //   style: biggerTextStyle,
          // ),
          ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BigText('Profile'),
            const VerticalSpace(48),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Get.defaultDialog(
                    title: 'upload profile picture',
                    content: const UploadProfilePictureWidget(),

                    // onConfirm: () => build(Get.context!),
                  ).then((value) {
                    setState(() {});
                  }),
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                            color: primaryColor,
                            // borderRadius: BorderRadius.circular(50),
                            shape: BoxShape.circle),
                        child: ClipOval(
                          // borderRadius: BorderRadius.circular(radius),
                          // width: 100,
                          // height: 100,
                          // decoration: const BoxDecoration(

                          // borderRadius: BorderRadius.circular(50),
                          // shape: BoxShape.circle),

                          // backgroundColor: p,
                          // radius: 50,
                          child: MyNetworkImage(
                            key: Key(DateTime.now()
                                .millisecondsSinceEpoch
                                .toString()),
                            path: path,
                            fit: BoxFit.cover,
                          ),
                          // Image.asset(
                          // '${apiUrl}profile-image',
                          // fit: BoxFit.fill,
                          // ),
                        ),
                      ),
                      const Positioned(
                          top: 0,
                          right: 0,
                          child: Icon(
                            Icons.add_a_photo,
                            color: primaryDarkColor,
                          ))
                    ],
                  ),
                ),
                const HorizontalSpace(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallText(
                      name,
                      fontSize: 20,
                      // style: bigTextStyle,
                    ),
                    SmallText(
                      "Edit Profile",
                      color: Colors.grey.shade700,
                      // style: biggerTextStyle,
                    )
                  ],
                )
              ],
            ),
            const VerticalSpace(48),
            Expanded(
              child: DefaultTextStyle.merge(
                  child: ListView.builder(
                      itemCount: libraryItems.length,
                      itemBuilder: (_, i) {
                        final item = libraryItems[i];
                        return Column(
                          children: [
                            MyListTile(
                              icon: item.icon,
                              onTap: item.onTap,
                              text: item.title,
                            ),
                            const Divider(
                              height: 6,
                            ),
                          ],
                        );
                      })
                  //     child: ListView(children: const [
                  //   Card(
                  //     child: ListTile(
                  //       leading: Icon(Icons.play_circle_filled),
                  //       title: Text('History'),
                  //       trailing: Icon(Icons.arrow_forward_ios),
                  //     ),
                  //   )
                  // ])
                  ),
            ),
            MyButton(
                onTap: () => Get.offNamed(Routes.HOSTDASHBOARD),
                child: const Text('Go to Host dashboard')),
          ],
        ),
      ),
    ));
    // return Scaffold(
    //   body: SafeArea(
    //       child: Column(children: [
    //     Container(
    //       alignment: Alignment.topLeft,
    //       padding: const EdgeInsets.only(bottom: 20, left: 30),
    //       child: Text(
    //         "LIbrary",
    //         // style: theme.headline1!.copyWith(fontSize: 15),
    //       ),
    //     ),
    //     ...List.generate(
    //         tileItems.length,
    //         (index) => Container(
    //               padding: const EdgeInsets.symmetric(horizontal: 30),
    //               decoration: const BoxDecoration(),
    //               child: ListTile(
    //                 leading: tileLeading[index],
    //                 title: Text(
    //                   tileItems[index]["title"],
    //                   // style: ,
    //                 ),
    //                 trailing: const Icon(Icons.arrow_forward_ios),
    //               ),
    //             )),
    //   ])),
    // );
  }
}
