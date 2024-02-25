import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';

class HostLectureItem extends StatelessWidget {
  const HostLectureItem({
    super.key,
    required this.onTap,
    // required this.onTapMenu,
    required this.lecture,
    required this.popUpActions,
  });

  final Lecture lecture;

  final List<PopupMenuItem<dynamic>> popUpActions;

  final Function(Lecture lecture) onTap;
  // final Function(Lecture lecture) onTapMenu;
  // final VoidCallback onTapMenu;

  // final defaultImageAsset = 'assets/pic_two.png';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(lecture);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: MyNetworkImage(
                          path: lecture.thumb,
                          useAppRequest: false,
                          fit: BoxFit.fill,
                          height: 60,
                          width: 60,
                        ) /* Image.network(
                          lecture.thumb,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              defaultImageAsset,
                              fit: BoxFit.fill,
                              height: 60,
                              width: 60,
                            );
                          },
                          fit: BoxFit.fill,
                          height: 60,
                          width: 60,
                        )*/
                        /*Image(
                        fit: BoxFit.fill,
                        width: 60,
                        height: 60,
                        image: AssetImage(image),
                      )*/
                        ),
                    const HorizontalSpace(16),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(child: SmallText(lecture.title)),
                            ],
                          ),
                          const VerticalSpace(2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: SmallText(
                                  formatDate(lecture.createdAt),
                                  fontSize: 12,
                                  color: Colors.grey,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const HorizontalSpace(8),
                              SmallText(
                                formatLength(lecture.duration),
                                fontSize: 12,
                                color: Colors.grey,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  PopupMenuButton(itemBuilder: (_) {
                    return popUpActions;
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
