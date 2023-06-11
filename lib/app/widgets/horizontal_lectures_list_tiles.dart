import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/lecture_player.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class HorizontalLectureListTiles extends StatelessWidget {
  final String label;
  final List<Lecture> lectures;
  const HorizontalLectureListTiles(
      {Key? key, required this.label, required this.lectures})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: bigTextStyle,
                // style: theme.headline1!.copyWith(fontSize: 13),
              )),
          VerticalSpace(),
          SizedBox(
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: lectures.length,
                itemBuilder: (_, i) {
                  final lecture = lectures[i];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          LecturePlayerScreen(lecture.title, lecture.url));
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Column(
                        children: [
                          Container(
                            height: 90,
                            width: 100,
                            child: Image.network(lecture.thumb),
                            margin: const EdgeInsets.only(right: 9),
                            decoration: BoxDecoration(
                                // color: Colors.black,
                                borderRadius: BorderRadius.circular(9)),
                          ),
                          VerticalSpace(),
                          Text(
                            lecture.title,
                            overflow: TextOverflow.ellipsis,
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
