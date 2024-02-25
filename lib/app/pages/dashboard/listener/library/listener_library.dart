import 'package:at_tareeq/app/data/enums/library_type.dart';
import 'package:at_tareeq/app/data/models/my_list_item.dart';
import 'package:at_tareeq/app/widgets/my_iist_tile.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerLibrary extends StatelessWidget {
  const ListenerLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryItems = <MyListItem>[
      MyListItem(const Icon(Icons.play_circle_fill_rounded), 'history', () {
        Get.toNamed(Routes.LIBRARYLECTURES,
            arguments: {'type': LibraryType.history});
      }),
      MyListItem(const Icon(Icons.bookmark_rounded), 'Play Later', () {
        Get.toNamed(Routes.LIBRARYLECTURES,
            arguments: {'type': LibraryType.playLater});
      }),
      MyListItem(const Icon(Icons.playlist_play_rounded), 'Playlist', () {
        Get.toNamed(Routes.PLAYLISTS);
      }),
      MyListItem(const Icon(Icons.favorite_rounded), 'Favourite', () {
        Get.toNamed(Routes  .LIBRARYLECTURES,
            arguments: {'type': LibraryType.favorite});
      }),
      MyListItem(const Icon(Icons.save_alt_rounded), 'Downloads', () {
        Get.toNamed(Routes.DOWNLOADS);
      }),
    ];

    return Scaffold(
      appBar: AppBar(
    title: const BigText(
      'Library',
    ),
      ),
      body: Container(
    margin: const EdgeInsets.only(top: 40),
    // style: biggestTextStyle,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
            itemCount: libraryItems.length,
            itemBuilder: (_, i) {
              final item = libraryItems[i];
              return Column(
                children: [
                  MyListTile(icon: item.icon, onTap: item.onTap, text: item.title,),
                                const Divider(height: 6,),
                ],
              );
              // return Card(
              //   child: ListTile(
              //     onTap: item.onTap,
              //     leading: item.icon,
              //     title: Text(item.title),
              //     trailing: const Icon(Icons.arrow_forward_ios),
              //   ),
              // );
            }),
      )
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
    );
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
