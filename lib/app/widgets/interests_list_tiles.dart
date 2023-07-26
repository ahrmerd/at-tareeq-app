import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:flutter/material.dart';

class InterestsListTiles extends StatelessWidget {
  final String label;
  final List<SectionOrInterest> interests;
  final void Function(SectionOrInterest interest) onTap;
  const InterestsListTiles(
      {Key? key,
      required this.label,
      required this.interests,
      required this.onTap})
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
                itemCount: interests.length,
                itemBuilder: (_, i) {
                  final interest = interests[i];
                  return GestureDetector(
                    onTap: () => onTap(interest),
                    child: Column(
                      children: [
                        Container(
                          height: 90,
                          width: 100,
                          margin: const EdgeInsets.only(right: 9),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9)),
                          child: Image.network(interest.thumb),
                        ),
                        Text(interest.name),
                        // Text(interest.title)
                      ],
                    ),
                  );
                }),
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
