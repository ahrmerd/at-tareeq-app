import 'dart:typed_data';

import 'package:at_tareeq/app/dependancies.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatefulWidget {
  final String path;
  final bool useAppRequest;

  final double? width;

  final double? height;

  final Color? color;

  final BoxFit? fit;

  final Alignment alignment;

  final String fallbackAsset;
  const MyNetworkImage({
    this.fallbackAsset = 'assets/icon.png',
    super.key,
    required this.path,
    this.useAppRequest = true,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment = Alignment.center,
  });

  @override
  State<MyNetworkImage> createState() => _MyNetworkImageState();
}

class _MyNetworkImageState extends State<MyNetworkImage> {
  late Future<Uint8List> futureImage;
  @override
  void initState() {
    super.initState();

    futureImage = getImage();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureImage,
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            height: widget.height,
            width: widget.width,
            color: widget.color,
            fit: widget.fit,
            alignment: widget.alignment,
          );
        } else if (snapshot.hasError) {
          return Image.asset(widget.fallbackAsset,
              height: widget.height,
              width: widget.width,
              color: widget.color,
              fit: widget.fit,
              alignment: widget.alignment);
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Future<Uint8List> getImage() async {
    final req = widget.useAppRequest ? Dependancies.http() : Dio();
    final res = await req.get(widget.path,
        options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList((res.data) as List<int>);
  }
}
