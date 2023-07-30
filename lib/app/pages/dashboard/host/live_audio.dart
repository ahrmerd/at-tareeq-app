import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

class LiveAudio extends StatefulWidget {
  const LiveAudio({
    Key? key,
    // required this.bottomWidget,
  }) : super(key: key);

  // final Widget? bottomWidget;

  @override
  State<LiveAudio> createState() => _LiveAudioState();
}

class _LiveAudioState extends State<LiveAudio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: CustomColor.appBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    'assets/pic_two.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            'Title',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          SmallText(
                            'Lecturer',
                            fontSize: 15,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
      // bottomSheet: widget.bottomWidget,
    );
  }
}
