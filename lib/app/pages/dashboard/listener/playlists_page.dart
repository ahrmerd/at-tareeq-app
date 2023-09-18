import 'package:at_tareeq/app/controllers/playlist_controller.dart';
import 'package:at_tareeq/app/data/models/playlist.dart';
import 'package:at_tareeq/app/data/repositories/playlist_repository.dart';
import 'package:at_tareeq/app/pages/pagination_builder.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlists')),
      body: PaginationBuilder(
        paginator: PlaylistRepository()
            .paginator(perPage: 10, query: {"include": 'lectures'}),
        onSuccess: (scrollController, data, isFetchingMore, refresh) {
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (_, i) {
                        final Playlist playlist = data[i];
                        return Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(() => Builder(builder: (_) {
                                    return Scaffold(
                                        appBar: AppBar(
                                          title: BigText(playlist.name),
                                        ),
                                        body: VerticalLectureListView(
                                          label: playlist.name,
                                          lectures: playlist.lectures ?? [],
                                        ));
                                  }));
                            },
                            title: Text(playlist.name),
                          ),
                        );
                      })),
              if (isFetchingMore) CircularProgressIndicator()
            ],
          );
        },
      ),
      // body: controller.obx(
      //   (state) => ListView.builder(
      //       itemCount: controller.state!.length,
      //       itemBuilder: (_, i) {
      //         final playlist = controller.state![i];
      //         return Card(
      //           child: ListTile(
      //             onTap: () {
      //               Get.to(() => Builder(builder: (_) {
      //                     return Scaffold(
      //                         appBar: AppBar(
      //                           title: BigText(playlist.name),
      //                         ),
      //                         body: VerticalLectureListView(
      //                             label: playlist.name,
      //                             lectures: playlist.lectures ?? []));
      //                   }));
      //             },
      //             title: Text(playlist.name),
      //           ),
      //         );
      //       }),
      //   // onAddToFavorite: addToFavorite,
      //   // onAddToPlaylater: addToPlaylater,

      //   onEmpty: EmptyScreen(onRetry: () {
      //     controller.fetchPlaylists();
      //   }),
      //   onError: (error) => ErrorScreen(
      //       messsage: error,
      //       onRetry: () {
      //         controller.fetchPlaylists();
      //       }),
      //   onLoading: const LoadingScreen(),
      // ),
    );
  }
}
