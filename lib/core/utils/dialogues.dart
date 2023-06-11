import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorDialogue([String message = "an error occured"]) {
  Get.defaultDialog(title: "Error", middleText: message, actions: [
    TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text("Close"),
    ),
  ]);
}

void showDialogue(
    {String title = 'Info', String message = "an error occured"}) {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
  Get.defaultDialog(title: title, middleText: message, actions: [
    TextButton(
      onPressed: () {
        Get.back();
      },
      child: const Text("Close"),
    ),
  ]);
}
