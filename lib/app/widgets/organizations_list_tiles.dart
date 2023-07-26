import 'package:at_tareeq/app/data/models/user.dart';
import 'package:flutter/material.dart';

class OrganizationsListTiles extends StatelessWidget {
  final String label;
  final List<User> users;
  final void Function(User organization) onTap;

  const OrganizationsListTiles(
      {Key? key, required this.label, required this.users, required this.onTap})
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
                // style: theme.headline1!.copyWith(fontSize: 13),
              )),
          SizedBox(
            height: 150,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (_, i) {
                  final user = users[i];

                  return GestureDetector(
                    onTap: () => onTap(user),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 100,
                          margin: const EdgeInsets.only(right: 9),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9)),
                          child: Image.network(user.thumb),
                        ),
                        Text(user.organization ?? 'Unknown Organization'),
                        // Text()
                      ],
                    ),
                  );
                }),
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
