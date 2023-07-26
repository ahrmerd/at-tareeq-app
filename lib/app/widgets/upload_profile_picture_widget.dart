import 'dart:io';

import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/error_screen.dart';
import 'screens/success_screen.dart';
import 'widgets.dart';

class UploadProfilePictureWidget extends StatefulWidget {
  const UploadProfilePictureWidget({super.key});

  @override
  State<UploadProfilePictureWidget> createState() =>
      _UploadProfilePictureWidgetState();
}

class _UploadProfilePictureWidgetState
    extends State<UploadProfilePictureWidget> {
  var status = ProcessingStatus.initial;
  File? file;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ProcessingStatus.initial:
        return SizedBox(
          // height: Get.height - 50,
          child: SingleChildScrollView(
            child: Column(children: [
              const VerticalSpace(20),
              MyButton(
                onTap: onPickImage,
                child: const Text('Pick Image'),
              ),
              const VerticalSpace(15),
              if (file != null) ...[
                SizedBox(
                  height: 400,
                  // width: 400,
                  child: Image.file(
                    file!,
                    fit: BoxFit.cover,
                  ),
                ),
                const VerticalSpace(),
                MyButton(
                  onTap: uploadImage,
                  child: const Text('upload Image'),
                )
              ],
            ]),
          ),
        );
      case ProcessingStatus.success:
        return const SuccessScreen();
      case ProcessingStatus.error:
        return const ErrorScreen();
      case ProcessingStatus.loading:
        return const CircularProgressIndicator();
    }
  }

  onPickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) {
      Get.showSnackbar(GetSnackBar(
        duration: 2.seconds,
        backgroundColor: Colors.red.shade200,
        borderColor: primaryColor,
        title: 'File not selected',
        message: 'You didnt select another file',
      ));
    } else {
      if (result.count > 0) {
        setState(() {
          file = File(result.files.first.path!);
        });
      }
    }
  }

  uploadImage() async {
    try {
      if (file != null) {
        setState(() {
          status = ProcessingStatus.loading;
        });
        final formFile = await dioLib.MultipartFile.fromFile(file!.path);
        dioLib.FormData formData = dioLib.FormData.fromMap({'image': formFile});
        await Dependancies.http().post('profile-image', data: formData);
        setState(() {
          status = ProcessingStatus.success;
        });
        Get.back();
      }
    } on Exception {
      showErrorDialogue();
      setState(() {
        status = ProcessingStatus.initial;
      });
    }
  }
}
