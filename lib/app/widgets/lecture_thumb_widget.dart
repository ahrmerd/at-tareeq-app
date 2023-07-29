import 'package:flutter/material.dart';

class LectureThumbWidget extends StatelessWidget {
  const LectureThumbWidget(
      {super.key, required this.url, this.boxFit, this.height, this.width});
  final String url;
  final defaultImageAsset = 'assets/pic_two.png';
  final BoxFit? boxFit;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          defaultImageAsset,
          fit: boxFit,
          height: height,
          width: width,
        );
      },
      fit: boxFit,
      height: height,
      width: width,
    );
  }
}
