import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DelectionConfirmationDialogue<T> extends StatefulWidget {
  // final T item;
  final String? message;
  final Future<void> Function() onConfirmDelete;
  const DelectionConfirmationDialogue(
      {super.key, required this.onConfirmDelete, this.message});

  @override
  State<DelectionConfirmationDialogue<T>> createState() =>
      _DelectionConfirmationDialogueState<T>();
}

class _DelectionConfirmationDialogueState<T>
    extends State<DelectionConfirmationDialogue<T>> {
  // bool isLoading = false;
  ProcessingStatus _status = ProcessingStatus.initial;

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case ProcessingStatus.loading:
        return AlertDialog(
          content: Center(child: ColorLoader()),
        );
      case ProcessingStatus.error:
        return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              MyButton(
                onTap: () {
                  Get.back();
                },
                child: const Text("Close"),
              ),
            ],
            content: ErrorScreen(
              messsage: "Couldnt perfrom. refresh the page before trying again",
            ));
      case ProcessingStatus.initial:
      case ProcessingStatus.success:
        return AlertDialog(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          titlePadding: const EdgeInsets.all(8),
          contentPadding: const EdgeInsets.all(8),

          backgroundColor: Get.theme.dialogBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text("Warning",
              textAlign: TextAlign.center, style: dangerTextStyle),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    widget.message ??
                        "Are you sure you want to proceed with the delection",
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              ButtonTheme(
                minWidth: 78.0,
                height: 34.0,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // my
                    MyButton(
                      danger: true,
                      onTap: () async {
                        setState(() {
                          _status = ProcessingStatus.loading;
                        });
                        try {
                          await widget.onConfirmDelete();
                          setState(() {
                            _status = ProcessingStatus.success;
                          });
                          Get.back();
                        } on Exception catch (e) {
                          Dependancies.errorService.addErrorWithCallback(
                              callback: () {
                                setState(() {
                                  _status = ProcessingStatus.error;
                                });
                              },
                              exception: e);
                        }
                        // setState(() {
                        //   isLoading = false;
                        // });
                        // LectureRepository.deleteLecture(lecture)
                        //     .then((value) {
                        //   widget.onRefresh();
                        // });
                        // widget.onRefresh;
                        // confirmedDeleteLecture(lecture);
                      },
                      child: const Text("Confirm"),
                    ),
                    MyButton(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              )
            ],
          ),
          // actions: actions, // ?? <Widget>[cancelButton, confirmButton],
          buttonPadding: EdgeInsets.zero,
        );
    }
  }
}
