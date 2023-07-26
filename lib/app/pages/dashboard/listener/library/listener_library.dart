import 'package:at_tareeq/app/data/enums/library_type.dart';
import 'package:at_tareeq/app/data/models/my_list_item.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerLibrary extends StatelessWidget {
  const ListenerLibrary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final libraryItems = <MyListItem>[
      MyListItem(const Icon(Icons.play_circle), 'history', () {
        Get.toNamed(Routes.LIBRARYLECTURES,
            arguments: {'type': LibraryType.history});
      }),
      MyListItem(const Icon(Icons.bookmark), 'Play Later', () {
        Get.toNamed(Routes.LIBRARYLECTURES,
            arguments: {'type': LibraryType.playLater});
      }),
      MyListItem(const Icon(Icons.playlist_play), 'Playlist', () {}),
      MyListItem(const Icon(Icons.favorite), 'Favoutite', () {
        Get.toNamed(Routes.LIBRARYLECTURES,
            arguments: {'type': LibraryType.favorite});
      }),
      MyListItem(const Icon(Icons.download), 'Downloads', () {}),
    ];

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Library',
          style: biggerTextStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(8),
        child: DefaultTextStyle.merge(
            child: ListView.builder(
                itemCount: libraryItems.length,
                itemBuilder: (_, i) {
                  final item = libraryItems[i];
                  return Card(
                    child: ListTile(
                      onTap: item.onTap,
                      leading: item.icon,
                      title: Text(item.title),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
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
