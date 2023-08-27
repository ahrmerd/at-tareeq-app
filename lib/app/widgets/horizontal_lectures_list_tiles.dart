import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/lecture_player.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HorizontalLectureListTiles extends StatelessWidget {
  final String label;
  final List<Lecture> lectures;
  
  final bool isPrimary;
  
  const HorizontalLectureListTiles(
      {Key? key, required this.label, required this.lectures, 
      this.isPrimary = true,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: biggerTextStyle,
                // style: theme.headline1!.copyWith(fontSize: 13),
              )),
          const VerticalSpace(),
          SizedBox(
            height: 170,
            child: ListView.builder(
      primary: isPrimary,
                scrollDirection: Axis.horizontal,
                itemCount: lectures.length,
                itemBuilder: (_, i) {
                  final lecture = lectures[i];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => LecturePlayerScreen(lecture));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 15),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: MyNetworkImage(
                              fit: BoxFit.fill,
                                path: lecture.thumb,
                                useAppRequest: false,
                                height: 120,
                                width: 120),
                          ),
                          
                          const VerticalSpace(2),
                          SmallText(
                            lecture.title,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                          const VerticalSpace(2),
                          SmallText(
                            
                            lecture.user?.organization ?? lecture.user?.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            fontSize: 12,
                            color: Colors.grey,
                            softWrap: false,
                          ),
                    
                          // Text(
                          //   lecture.title,
                          //   overflow: TextOverflow.ellipsis,
                          // )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: List.generate(lectures.length, (index) {
          //       final lecture = lectures[index];
          //       return Column(
          //         children: [
          //           Container(
          //             height: 90,
          //             width: 100,
          //             margin: const EdgeInsets.only(right: 9),
          //             decoration: BoxDecoration(
          //                 color: Colors.black,
          //                 borderRadius: BorderRadius.circular(9)),
          //           ),
          //           Text(lecture.title),
          //           Text(lecture.title)
          //         ],
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
