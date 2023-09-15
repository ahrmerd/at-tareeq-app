import 'package:at_tareeq/app/controllers/playlist_controller.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlaylistsPage extends GetView<PlaylistController> {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlists')),
      body: controller.obx(
        (state) => ListView.builder(
          itemCount: controller.state!.length,
          itemBuilder:(_, i){
          final playlist = controller.state![i];
          return Card(
            child: ListTile(
              onTap: (){
                Get.to(()=>Builder(builder: (_){
                  return Scaffold(
                    appBar: AppBar(title: BigText(playlist.name),),
                    body:VerticalLectureListView(label: playlist.name, lectures: playlist.lectures??[])
                  );
                }) );
              },
              title: Text(playlist.name),
            ),
          );
        } ),
          // onAddToFavorite: addToFavorite,
          // onAddToPlaylater: addToPlaylater,

        onEmpty: const EmptyScreen(),
        onError: (error) => ErrorScreen(
          messsage: error,
          onRetry: (){
           controller.fetchPlaylists();
          } 
        ),
        onLoading: const LoadingScreen(),
      ),
    );
  }
}
