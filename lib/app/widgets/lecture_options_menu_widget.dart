
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/library_item.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/repositories/library_repository.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/downloader.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LectureOptionsMenuWidget extends StatefulWidget {
  final Lecture lecture;
  // final controller = Dependancies.audioOptionsMenu;

  const LectureOptionsMenuWidget({super.key, required this.lecture});

  @override
  State<LectureOptionsMenuWidget> createState() =>
      _LectureOptionsMenuWidgetState();
}

class _LectureOptionsMenuWidgetState extends State<LectureOptionsMenuWidget> {
  bool _isOpen = false;

  void closeMenu() {
    setState(() {
      _isOpen = false;
    });
  }

  // List<String> favouritesId= SharedPreferencesHelper.getFavorites();
  // List<String> playlatersId= SharedPreferencesHelper.getPlaylater();
  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: _isOpen,
      fit: StackFit.expand,
      portalFollower: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        // crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          _menuItem(),
        ],
      ),
      // anchor: Filled(),
      // anchor: Aligned(
      //   alignToPortal: AxisFlag(x: true, y:true),
      //     follower: Alignment.topCenter,
      //     target: Alignment.topLeft
      //     ),
      child: IconButton(
        onPressed: () {
          // getApplicationSupportDirectory().then((value) => print(value));
          getApplicationDocumentsDirectory().then((dir) {
            dir.list(recursive: true).forEach((f) {
              print(f);
            });
          });

          setState(() {
            _isOpen = true;
          });
          // Dependancies.audioOptionsMenu.openMenu(item);
          // controller.toggle();
        },
        icon: const Icon(Icons.more_vert_rounded),
      ),
    );
  }

  Widget _menuItem() => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: CustomColor.appBlue.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12), topLeft: Radius.circular(12)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MyNetworkImage(
                                path: widget.lecture.thumb,
                                height: 64,
                                width: 64,
                              ),
                            ),
                            // ttat
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  widget.lecture.title,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SmallText(
                                  widget.lecture.user?.getOrganization() ?? "",
                                  fontSize: 15,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        )),
                        IconButton(
                          icon:
                              SharedPreferencesHelper.checkIfLectureInFavorites(
                                          widget.lecture) !=
                                      null
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline_rounded,
                                      color: Colors.white,
                                    ),
                          onPressed: () {
                            final libraryItemId = SharedPreferencesHelper
                                .checkIfLectureInFavorites(widget.lecture);
                            print(libraryItemId ?? 'nill');
                            if (libraryItemId != null) {
                              removeFromFavorite(LibraryItem.fromLecture(
                                  int.parse(libraryItemId), widget.lecture));
                              closeMenu();
                              return;
                            }
                            addToFavorite(widget.lecture);
                            closeMenu();
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isOpen = false;
                            });
                            // controller.closeMenu();
                            // AudioOptionsMenuWidget.toggleMenu(false);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AudioPlayerOptionsMenuItem(
                          icon: Icons.watch_later_outlined,
                          text: SharedPreferencesHelper
                                      .checkIfLectureInPlaylaters(
                                          widget.lecture) !=
                                  null
                              ? 'Remove from Playlater'
                              : 'Add to Playlater',
                          onTap: () {
                            final libraryItemId = SharedPreferencesHelper
                                .checkIfLectureInPlaylaters(widget.lecture);
                            if (libraryItemId != null) {
                              removeFromPlaylater(LibraryItem.fromLecture(
                                  int.parse(libraryItemId), widget.lecture));
                              closeMenu();
                              return;
                            }
                            addToPlaylater(widget.lecture);
                            closeMenu();
                            // print('tapped');
                            // LibraryRepository.RefreshFavorites();
                          },
                        ),

                        // AudioPlayerOptionsMenuItem(
                        //     icon: Icons.skip_next, text: 'Play Next'),
                        // const AudioPlayerOptionsMenuItem(
                        //     icon: Icons.playlist_add, text: 'Add to Playlist'),
                        AudioPlayerOptionsMenuItem(
                          icon: Icons.download_rounded,
                          text: 'Download',
                          onTap: () {
                            Downloader.downloadLecture(widget.lecture);
                            closeMenu();
                          },
                        ),
                        AudioPlayerOptionsMenuItem(
                          icon: Icons.person_rounded,
                          text: 'View Host',
                          onTap: () {
                            Get.toNamed(Routes.USERLECTURES,
                                arguments: {'user': widget.lecture.user});
                          },
                        ),

                        AudioPlayerOptionsMenuItem(
                            icon: Icons.share_outlined, text: 'Share', onTap: (){
                              Share.share("check out this amazing lecture, titled '${widget.lecture.title}' by ${widget.lecture.user?.getOrganization()??'unknown individual'}. $url/lectures/${widget.lecture.id}/download2");
                              closeMenu();
                            },),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class AudioPlayerOptionsMenuItem extends StatelessWidget {
  const AudioPlayerOptionsMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: key);

  final void Function()? onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 16,
            ),
            SmallText(
              text,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
