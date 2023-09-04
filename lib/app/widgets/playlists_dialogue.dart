import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/playlist.dart';
import 'package:at_tareeq/app/data/repositories/playlist_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaylistsDialogue extends StatefulWidget {
  const PlaylistsDialogue({super.key, required this.lecture});
  final Lecture lecture;

  @override
  State<PlaylistsDialogue> createState() => _PlaylistsDialogueState();
}

class _PlaylistsDialogueState extends State<PlaylistsDialogue> {
  // late Future<List<Playlist>> future;

  List<Playlist> filteredPlaylists = [];
  bool get hasNoItems => filteredPlaylists.isEmpty;
  final List<Playlist> playlists = [];
  final TextEditingController _searchController = TextEditingController();
  ProcessingStatus processingStatus = ProcessingStatus.initial;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initPlaylists();
    _searchController.addListener(() {
      final String text = _searchController.text.toLowerCase();
      setState(() {
        filteredPlaylists =
            playlists.where((element) => element.name.contains(text)).toList();
      });
    });

    //  future = getPlayLists();
    //  future.then((value){
    //     playlists.addAll(value);
    //     filteredPlaylists.addAll(value);
    //  });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (processingStatus) {
      case ProcessingStatus.loading:
      case ProcessingStatus.initial:
        return ColorLoader();
      case ProcessingStatus.success:
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: myInputDecoration(
                            label: 'Search or Create a playlist',
                            icon: Icon(Icons.search_off_rounded)),
                      ),
                    ),
                    HorizontalSpace(),
                    MyButton(
                      child: Icon(Icons.save_rounded),
                      onTap: createPlaylistAndLectureToPlaylist,
                    )
                  ],
                ),
                hasNoItems
                    ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: EmptyScreen(),
                    )
                    : Expanded(
                        child: ListView.builder(
                        
                            itemCount: filteredPlaylists.length,
                            itemBuilder: (_, i) {
                              Playlist playlist = filteredPlaylists[i];
                              return Card(
                                  child: ListTile(
                                    onTap: () {
                                      addLectureToPlaylsit(playlist);
                                    },
                                title: Text(playlist.name),
                              ));
                            }))
              ],
            ),
          ),
        );
      case ProcessingStatus.error:
        return ErrorScreen();
    }

    // return FutureBuilder(
    //   future: future,
    //   builder: (_, snapshot){
    //     switch(snapshot.connectionState){

    //       case ConnectionState.waiting:
    //       case ConnectionState.none:
    //       case ConnectionState.active:
    //         return Center(child: ColorLoader(),);
    //       case ConnectionState.done:
    //         if(snapshot.hasData){
    //           // return
    //           return Dialog(
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Column(children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Expanded(
    //                       child: TextField(
    //                         controller: _searchController,
    //                         decoration: myInputDecoration(label: 'Search or Create a playlist', icon: Icon(Icons.search_off_rounded)),
    //                       ),
    //                     ),
    //                     HorizontalSpace(),
    //                     MyButton(child: Icon(Icons.save_rounded), onTap: createPlaylistAndLectureToPlaylist, )
    //                   ],

    //                 ),
    //                 Expanded(child: ListView.builder(
    //                   itemCount: filteredPlaylists.length,
    //                   itemBuilder: (_, i){
    //                     Playlist playlist = filteredPlaylists[i];
    //                     return Card(child: ListTile(title: Text(playlist.name),));
    //                   }))
    //               ],),
    //             ),
    //           );

    //         }
    //         else if (snapshot.hasError){
    //           return ErrorScreen();
    //         }
    //         return Center(child: Text('No Playlist Available'),);
    //     }
    //   });
  }

  Future<List<Playlist>> getPlayLists() {
    return PlaylistRepository().fetchModels();
  }

  Future<void> initPlaylists() async {
    setState(() {
      processingStatus = ProcessingStatus.loading;
    });
    try {
      final fetched = await getPlayLists();
      playlists.addAll(fetched);
      filteredPlaylists.addAll(fetched);
      setState(() {
        processingStatus = ProcessingStatus.success;
      });
    } catch (_) {
      setState(() {
        processingStatus = ProcessingStatus.error;
      });
    }
  }

  Future<void> createPlaylistAndLectureToPlaylist() async {
    setState(() {
      processingStatus = ProcessingStatus.loading;
    });
    try {
      await Dependancies.http().post('playlists', data: {
        'name': _searchController.text,
        'lectures': [widget.lecture.id]
      });
      Get.back();
    } catch (e) {
        showErrorDialogue(e.toString());
      setState(() {
        processingStatus = ProcessingStatus.success;
      });
    }
  }
  
  Future<void> addLectureToPlaylsit(Playlist playlist) async {
    setState(() {
      processingStatus = ProcessingStatus.loading;
    });
    try {
      await Dependancies.http().post('playlists/${playlist.id}/lectures', data: {
        'id': widget.lecture.id
      });
      Get.back();
    } catch (e) {
        showErrorDialogue(e.toString());
      setState(() {
        processingStatus = ProcessingStatus.success;
      });
    }


  }
}
