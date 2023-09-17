import 'dart:io';

import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class Downloader {
  static downloadLecture(Lecture lecture) async {
    //  final res = await Dependancies.http().get('',
    //       options: Options(responseType: ResponseType.bytes));
    final urlPath = "lectures/${lecture.id}/download";
    final savePath = await completeLecturePath(lecture);
    if (!(await checkIfFileExist(lecture))) {
      Dependancies.http.download(urlPath, savePath,
          onReceiveProgress: ((count, total) => {
                if (count >= total)
                  {Get.snackbar('SuccessFull', "your download has finished")}
                else if (count >= total * 0.7 && count < total * 0.72)
                  {Get.snackbar('Progress', "your download is almost done")}
                else if (count >= total * 0.25 && count < total * 0.27)
                  {Get.snackbar('Progress', "your download is still going on")}
              }));
    } else {
      Get.snackbar('Warning',
          "File already exists please delete downloaded file before redownloading");
    }
    // File file = File(savePath);
    // return Uint8List.fromList((res.data) as List<int>);
  }

  static Future<String> getDownloadsPath() async {
    return '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}downloads${Platform.pathSeparator}lectures${Platform.pathSeparator}';
  }

  static Future<bool> checkIfFileExist(Lecture lecture) async {
    // final dir = Directory(await getDownloadsPath());

    final fileExist = File(await completeLecturePath(lecture)).existsSync();
    if (fileExist) {
      return true;
    } else {
      final dir = Directory(await completeLecturePath(lecture));
      if (dir.existsSync()) {
        dir.deleteSync();
      }
      return false;
    }
    // if(Directory())
  }

  static Future<List<File>> getDownloads() async {
    await Downloader.ensureDownloadFolderExist();
    return (Directory(await getDownloadsPath()))
        .listSync()
        .whereType<File>()
        .toList();
  }

  static String idTitleSeparator = '-';

  static String lectureTitleFromFile(File file) =>
      fileEntityBasename(file).split(idTitleSeparator).last;

  static Future<void> ensureDownloadFolderExist() async {
    final dir = Directory(await getDownloadsPath());
    return dir.createSync(recursive: true);
  }

  static String lectureFilename(Lecture lecture) =>
      '${lecture.id}$idTitleSeparator${lecture.title}';

  static Future<String> completeLecturePath(Lecture lecture) async =>
      '${await getDownloadsPath()}${lectureFilename(lecture)}';
}
