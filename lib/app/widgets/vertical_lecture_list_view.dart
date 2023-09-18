import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/lecture_player.dart';
import 'package:at_tareeq/app/widgets/lecture_options_menu_widget.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'playbutton.dart';

class VerticalLectureListView extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final List<Lecture> lectures;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  final Widget Function(Lecture lecture)? extraLectureItemWidget;
  // final void Function(Lecture lecture) onAddToFavorite;
  // final void Function(Lecture lecture) onAddToPlaylater;
  const VerticalLectureListView({
    super.key,
    required this.label,
    required this.lectures,
    // required this.onAddToFavorite,
    this.isPrimary = true,
    this.scrollController,
    this.isLoadingMore = false,
    this.extraLectureItemWidget,
    // required this.onAddToPlaylater
  });

  @override
  State<VerticalLectureListView> createState() =>
      _VerticalLectureListViewState();
}

class _VerticalLectureListViewState extends State<VerticalLectureListView> {
  Lecture? playingLecture;
  final player = Dependancies.audioPlayer();
  // bool isPlaying = false;
  PlayingStatus playingStatus = PlayingStatus.stopped;

  Future<void> playAudio(Lecture lecture) async {
    setState(() {
      playingStatus = PlayingStatus.waiting;
      playingLecture = lecture;
    });

    await player.setSourceUrl(lecture.url);
    player.resume();
    setState(() {
      playingStatus = PlayingStatus.playing;
    });
  }

  Future<void> pauseAudio() async {
    await player.pause();
    setState(() {
      playingStatus = PlayingStatus.paused;
    });
  }

  Future<void> stopAudio() async {
    player.stop();
    setState(() {
      playingStatus = PlayingStatus.stopped;
    });
  }

  bool isMenuOpened = false;
  // ExpandableController controller = ExpandableController(
  //   initialExpanded: isMenuOpened,
  // );
  Lecture? lectureInMenu;

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              // primary: widget.isPrimary,
              // shrinkWrap: true,
              controller: widget.scrollController,
              physics: BouncingScrollPhysics(),
              // physics: NeverScrollableScrollPhysics(),
              itemCount: widget.lectures.length,
              itemBuilder: (_, i) {
                final item = widget.lectures[i];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => LecturePlayerScreen(item));
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    margin:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.grey.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: MyNetworkImage(
                                      path: item.thumb,
                                      useAppRequest: false,
                                      fit: BoxFit.cover,
                                      height: 60,
                                      width: 60,
                                    )
                                    // Image(
                                    //   fit: BoxFit.fill,
                                    //   width: 60,
                                    //   height: 60,
                                    //   image: AssetImage(image),
                                    // ),
                                    ),
                                const HorizontalSpace(16),
                                // SizedBox(width: 16,),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SmallText(item.title),
                                      const HorizontalSpace(4),
                                      SmallText(
                                        item.description ?? "",
                                        fontSize: 14,
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              playingLecture?.id == item.id
                                  ? PlayButton(
                                      playingStatus: playingStatus,
                                      onPlay: () {
                                        playAudio(item);
                                      },
                                      onPause: () {
                                        pauseAudio();
                                      },
                                      onStop: () {
                                        stopAudio();
                                      },
                                    )
                                  : GestureDetector(
                                      onTap: () => playAudio(item),
                                      child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(
                                              color: CustomColor.appPurple,
                                              shape: BoxShape.circle),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                          )),
                                    ),
                              const SizedBox(
                                width: 9,
                              ),
                              widget.extraLectureItemWidget?.call(item) ??
                                  SizedBox(),
                              LectureOptionsMenuWidget(
                                lecture: item,
                                // controller: controller,
                              ),
                              // PopupMenuButton(itemBuilder: (_) {
                              //   return [
                              //     PopupMenuItem(
                              //       child: const Text('Add to favorite'),
                              //       onTap: () => addToFavorite(item),
                              //     ),
                              //     PopupMenuItem(
                              //       child: const Text('Add to playlater'),
                              //       onTap: () => addToPlaylater(item),
                              //     ),
                              //   ];
                              // }),
                              // Icon(Icons.more_vert_rounded)

                              // IconButton(onPressed: onTapPlay, icon: Icon(Icons.play_circle_fill_rounded, color: CustomColor.appPurple, size: 32,)),
                              // IconButton(onPressed: onTapMenu, icon: Icon(Icons.more_vert_rounded)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        if (widget.isLoadingMore)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        // PortalTarget(
        //   visible: isMenuOpened,
        //   portalFollower: asin(x),
        //   child: child);
      ],
    );
  }
}



// Card(
//                     clipBehavior: Clip.antiAlias,
//         margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
//         elevation: 0,
//             child: ListTile(
//               onTap: () {
//                 Get.to(() => LecturePlayerScreen(item));
//                 // playAudio(item);
//               },
//               leading: Container(
//                   height: 60,
//                   width: 60,
//                   decoration: BoxDecoration(
//                       // color: Colors.black,
//                       borderRadius: BorderRadius.circular(9)),
          
//                   child: MyNetworkImage(path: item.thumb, useAppRequest: false, fit: BoxFit.contain)),
//               title: Text(
//                 item.title,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               // subtitle: Text(item.description),
//               trailing: SizedBox(
//                 width: 130,
//                 child: Row(
//                   children: [
//                     playingLecture?.id == item.id
//                         ? PlayButton(
//                             playingStatus: playingStatus,
//                             onPlay: () {
//                               playAudio(item);
//                             },
//                             onPause: () {
//                               pauseAudio();
//                             },
//                             onStop: () {
//                               stopAudio();
//                             },
//                           )
//                         : GestureDetector(
//                             onTap: () => playAudio(item),
//                             child: Container(
//                                 alignment: Alignment.center,
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: const BoxDecoration(
//                                     color: primaryLightColor,
//                                     shape: BoxShape.circle),
//                                 child: const Icon(
//                                   Icons.play_arrow,
//                                   color: Colors.white,
//                                 )),
//                           ),
//                     const SizedBox(
//                       width: 9,
//                     ),
//                     PopupMenuButton(itemBuilder: (_) {
//                       return [
//                         PopupMenuItem(
//                           child: const Text('Add to favorite'),
//                           onTap: () => addToFavorite(item),
//                         ),
//                         PopupMenuItem(
//                           child: const Text('Add to playlater'),
//                           onTap: () => addToPlaylater(item),
//                         ),
//                       ];
//                     }),
//                     // Icon(Icons.more_vert_rounded)
//                   ],
//                 ),
//               ),
//             ),
//           );

