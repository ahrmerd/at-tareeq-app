import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LiveStreamDetails extends StatelessWidget {
  const LiveStreamDetails({
    super.key,
    required this.lecturer,
    required this.title,
  });

  final String lecturer;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigText(
                title,
                fontSize: 16,
                color: Colors.black,
              ),
              const SizedBox(
                height: 6,
              ),
              SmallText(
                lecturer,
                fontSize: 15,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}