import 'package:at_tareeq/app/controllers/playlist_controller.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/playlist.dart';
import 'package:at_tareeq/app/data/repositories/playlist_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/pagination_builder.dart';
import 'package:at_tareeq/app/widgets/deletion_dialogue.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  VoidCallback? triggerRefresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlists')),
      body: PaginationBuilder(
        paginator: PlaylistRepository()
            .paginator(perPage: 10, query: Query(includes: ['lectures'])),
        onSuccess: (scrollController, data, isFetchingMore, refresh) {
          triggerRefresh = refresh;
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
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                            extraLectureItemWidget: (lect) =>
                                                MyButton(
                                              danger: true,
                                              onTap: () {
                                                confirmDetachLectureFromPlaylist(
                                                    lecture: lect,
                                                    playlist: playlist);
                                              },
                                              child: Icon(
                                                Icons.delete_forever_outlined,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ));
                                    }));
                              },
                              title: Text(playlist.name),
                              subtitle: Text(
                                "Created: ${formatDateTime(playlist.createdAt)}",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                              trailing: MyButton(
                                danger: true,
                                onTap: () async {
                                  confirmDeletePlaylist(playlist);
                                },
                                child: Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      })),
              if (isFetchingMore) CircularProgressIndicator()
            ],
          );
        },
      ),
    );
  }

  void confirmDeletePlaylist(Playlist playlist) {
    Get.dialog(
      DelectionConfirmationDialogue(
          message:
              "Are You sure you want to delete the playlist'${playlist.name}'. this action could be permanent",
          onConfirmDelete: () async {
            await deletePlaylist(playlist.id);
            setState(() {
              triggerRefresh?.call();
            });
            // Get.snackbar('Successfull', 'The Operation was succesful');
          }),
    );
  }

  void confirmDetachLectureFromPlaylist(
      {required Lecture lecture, required Playlist playlist}) {
    Get.dialog(
      DelectionConfirmationDialogue(
          message:
              "Are You sure you want to remove the lecture '${lecture.title}'. from Your Playlist.",
          onConfirmDelete: () async {
            await detachLectureFromPlaylsit(
                lectureId: lecture.id, playlistId: playlist.id);

            triggerRefresh?.call();

            // Get.snackbar('Successfull', 'The Operation was succesful');
          }),
    );
  }
}

Future<void> deletePlaylist(int playlistId) async {
  try {
    await Dependancies.http.delete('playlists/$playlistId');
    // Get.back();
  } on Exception catch (e) {
    Dependancies.errorService.addError(exception: e);
  }
}

Future<void> detachLectureFromPlaylsit(
    {required int playlistId, required int lectureId}) async {
  try {
    await Dependancies.http
        .delete('playlists/$playlistId/lectures', data: {'id': lectureId});
    Get.back();
  } on Exception catch (e) {
    Dependancies.errorService.addError(exception: e);
  }
}
