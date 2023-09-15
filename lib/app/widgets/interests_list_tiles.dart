import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class InterestsListTiles extends StatelessWidget {
  final String label;
  final List<SectionOrInterest> interests;
  final void Function(SectionOrInterest interest) onTap;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  // final bool usePagination;

  const InterestsListTiles({
    Key? key,
    required this.label,
    required this.interests,
    required this.onTap,
    this.scrollController,
    this.isLoadingMore = false,
    // this.usePagination = false,
  }) : super(key: key);

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
                style: biggerTextStyle,

                // style: theme.headline1!.copyWith(fontSize: 13),
              )),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: interests.length,
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      itemBuilder: (_, i) {
                        final interest = interests[i];
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: GestureDetector(
                            onTap: () => onTap(interest),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: MyNetworkImage(
                                    path: interest.thumb,
                                    fit: BoxFit.fill,
                                    width: 120,
                                    height: 140,
                                  ),
                                ),
                                const VerticalSpace(2),
                                SmallText(
                                  interest.name,
                                  fontSize: 14,
                                ),
                                // Text(interest.title)
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                if (isLoadingMore)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
              ],
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: List.generate(interest.length, (index) {
          //       final interest = interest[index];
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
          //           Text(interest.title),
          //           Text(interest.title)
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
