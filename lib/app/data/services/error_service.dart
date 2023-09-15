import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorService extends GetxService {
  static ErrorService instance = Get.find();
  final errorMessages = [].obs;

  final errorTitle = ''.obs;
  String dioErrorTitle = "Network error, ";
  String otherErrorTitle = "Some error, ";
  // String dioErrorString = "";

  String addError({
    required Exception exception,
  }) {
    String errorMessage = '';
    // String errorTitle = '';
    if (exception is DioError) {
      errorTitle.value.contains(dioErrorTitle)
          ? {}
          : errorTitle.value += dioErrorTitle;
      errorMessage = ApiClient.getDioErrorMessage(exception);
      // change(null, status: RxStatus.error(ApiClient.getDioErrorMessage(e)));
      // ApiClient.showErrorDialogue(e);
    } else {
            errorTitle.value.contains(otherErrorTitle)
          ? {}
          : errorTitle.value += otherErrorTitle;
      errorMessage = extractTextBeforeFullStop(exception);
    }
    if (!errorMessages.contains(errorMessage)) {
        errorMessages.add(errorMessage);
      }
    if (Get.isDialogOpen ?? false) {
      return errorMessage;
    } else {
      showDialogue();
      return errorMessage;
      // showDialog(context: context, builder: builder)
    }
  }

  String addStateMixinError({
    required Exception exception,
    // void Funtion(dynamic newState, {RxStatus? status})? gs,
    void Function(dynamic newState, {RxStatus? status})? stateChanger,
  }) {
    final errorMessage = addError(exception: exception);
    stateChanger != null
        ? stateChanger(null, status: RxStatus.error(errorMessage))
        : {};
    return errorMessage;
  }


  String addErrorWithCallback({
    required Exception exception,
    required VoidCallback callback,
    // void Funtion(dynamic newState, {RxStatus? status})? gs,
    // void Function(dynamic newState, {RxStatus? status})? stateChanger,
  }) {
    final errorMessage = addError(exception: exception);
    callback.call();
    // processingStatus = ProcessingStatus.error;
    // stateChanger != null
    //     ? stateChanger(null, status: RxStatus.error(errorMessage))
    //     : {};
    return errorMessage;
  }

  showDialogue() async {
    TextStyle? titleStyle;
    TextStyle? messageStyle;
    return Get.dialog(AlertDialog(
      titlePadding: const EdgeInsets.all(8),
      contentPadding: const EdgeInsets.all(8),

      backgroundColor: Get.theme.dialogBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Obx(() {
        return Text(errorTitle.value,
            textAlign: TextAlign.center, style: titleStyle);
      }),
      content: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...errorMessages
                .map(
                  (message) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message,
                        textAlign: TextAlign.center, style: messageStyle),
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
            ButtonTheme(
              minWidth: 78.0,
              height: 34.0,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () {
                      errorMessages.clear();
                      errorTitle.value = "";
                      Get.back();
                    },
                    child: const Text("Close"),
                  ),
                ],
              ),
            )
          ],
        );
      }),
      // actions: actions, // ?? <Widget>[cancelButton, confirmButton],
      buttonPadding: EdgeInsets.zero,
    ));

    // Obx((){
    // });
    // Get.defaultDialog(title: "Error", middleText: message, actions: [
    //   TextButton(
    //     onPressed: () {
    //       Get.back();
    //     },
    //     child: const Text("Close"),
    //   ),
    // ]);
  }
}


// void Funtion (T? newState, {RxStatus? status})