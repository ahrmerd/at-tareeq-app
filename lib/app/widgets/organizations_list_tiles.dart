import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class OrganizationsListTiles extends StatelessWidget {
  final String label;
  final List<User> users;
  final void Function(User organization) onTap;
  final ScrollController scrollController;
  final bool isLoadingMore;

  const OrganizationsListTiles({
    Key? key,
    required this.label,
    required this.users,
    required this.onTap,
    required this.scrollController,
    this.isLoadingMore = false,
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
                      itemCount: users.length,
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      itemBuilder: (_, i) {
                        final user = users[i];
                        return Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => onTap(user),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: MyNetworkImage(
                                      path: user.thumb,
                                      fit: BoxFit.fill,
                                      width: 120,
                                      height: 140,
                                    ),
                                  ),
                                  const VerticalSpace(2),
                                  SmallText(
                                    user.getOrganization(),
                                    fontSize: 14,
                                  ),
                                  // Text()
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                if (isLoadingMore)
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: List.generate(users.length, (index) {
          //       final lecture = users[index];
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
