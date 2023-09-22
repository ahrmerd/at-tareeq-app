import 'dart:io';

import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/extentions/string_extensions.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/core/values/const.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import 'package:media_store_plus/media_store_platform_interface.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saf/saf.dart';

class Downloader2 {
  static final mediaStorePlugin = MediaStore();
  static Future<void> init() async {
    MediaStore.appFolder = "At-Tareek";
    // MediaStorePlatform.instance.
    FileDownloader().configureNotification(
        running: const TaskNotification('Downloading', 'file: {filename}'),
        complete: const TaskNotification('Completed', 'file: {filename}'),
        progressBar: true);
    await FileDownloader().resumeFromBackground();
    FileDownloader().updates.listen((update) {
      // u
      if (update is TaskStatusUpdate) {
        switch (update.status) {
          case TaskStatus.enqueued:
          case TaskStatus.running:
          case TaskStatus.notFound:
          case TaskStatus.paused:
          case TaskStatus.waitingToRetry:
          case TaskStatus.canceled:
            break;
          case TaskStatus.complete:
            // FileDownloader().moveToSharedStorage(update.task, );
            Get.snackbar('Download Status Update',
                'The file: ${update.task.filename} has finished downloading');

            break;
          case TaskStatus.failed:
            Get.snackbar('Download Status Update',
                'The file: ${update.task.filename} failed to download');
            break;
        }
      }
    });
  }

  // static Future<void> ensureFolderPermission() async {
  //   Saf saf = Saf(localDownloadsPath);
  //   // await saf.getDirectoryPermission();
  //   print((await saf.getFilesPath()));
  // }

  static downloadLecture(Lecture lecture) async {
    // await ensureFolderPermission();
    //  final res = await Dependancies.http().get('',
    //       options: Options(responseType: ResponseType.bytes));
    final urlPath = "lectures/${lecture.id}/download2";
    final url = "${apiUrl.removeTrailing("/")}/$urlPath";

    // final savePath = await completeLecturePath(lecture);
    await Permission.notification.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    // final baseDir = print((await getApplicationSupportDirectory()).path);
    // print((await getExternalStorageDirectory())?.path);
    // print((await getExternalStorageDirectories())?.first.path);
    // final query = ApiClient.requestHeaders;
    // if (false) {
    await ensureDownloadFolderExist();
    if (!(await checkIfFileExist(lecture))) {
      final downloadTask = DownloadTask(
          taskId: "lecture-${lecture.id}",
          url: url,
          headers: ApiClient.requestHeaders,
          filename: lectureFilename(lecture),
          baseDirectory: BaseDirectory.applicationSupport,
          directory: lecturesLocalDownloadsPath,
          updates: Updates.statusAndProgress,
          retries: 5,
          allowPause: true);
      FileDownloader().moveToSharedStorage(downloadTask, SharedStorage.files);
      // FlutterDownloader.enqueue(
      //   // url: "${apiUrl.removeTrailing("/")}/$urlPath",
      //   url: url,
      //   headers: ApiClient.requestHeaders,
      //   fileName: lectureFilename(lecture),
      //   savedDir: await absoluteLecturesDownloadsPath,
      //   showNotification:
      //       true, // show download progress in status bar (for Android)
      //   openFileFromNotification:
      //       true, // click on notification to open downloaded file (for Android)
      // );
      final successfullyEnqueued = await FileDownloader().enqueue(downloadTask);
      Get.snackbar('Progress', "Your dowmload is starting");
      // Dependancies.http.download(urlPath, savePath,
      //     onReceiveProgress: ((count, total) => {
      //           if (count >= total)
      //             {Get.snackbar('SuccessFull', "your download has finished")}
      //           else if (count >= total * 0.7 && count < total * 0.72)
      //             {Get.snackbar('Progress', "your download is almost done")}
      //           else if (count >= total * 0.25 && count < total * 0.27)
      //             {Get.snackbar('Progress', "your download is still going on")}
      //         }));
    } else {
      Get.snackbar('Warning',
          "File already exists please delete downloaded file before redownloading");
    }
    // File file = File(savePath);
    // return Uint8List.fromList((res.data) as List<int>);
  }

  static final localDownloadsPath =
      'downloads${Platform.pathSeparator}At-Tareeq${Platform.pathSeparator}';

  static String get lecturesLocalDownloadsPath =>
      '${localDownloadsPath}lectures${Platform.pathSeparator}';

  static Future<String> get absoluteLecturesDownloadsPath async =>
      '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}$lecturesLocalDownloadsPath';

  // static Future<String> getDownloadsPath() async {
  //   // get
  //   return '${(await getApplicationSupportDirectory()).path}${Platform.pathSeparator}$downloadsLocalDirectory${Platform.pathSeparator}';
  // }

  static Future<bool> checkIfFileExist(Lecture lecture) async {
    // final dir = Directory(await getDownloadsPath());
    print(await completeLecturePath(lecture));
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
    // await ensureFolderPermission();
    await mediaStorePlugin.requestForAccess(initialRelativePath: "");
    // mediaStorePlugin.getDocumentTree(uriString: '');
    await ensureDownloadFolderExist();
    return (Directory(await absoluteLecturesDownloadsPath))
        .listSync()
        .whereType<File>()
        .toList();
  }

  static String idTitleSeparator = '-';

  static String lectureTitleFromFile(File file) =>
      fileEntityBasename(file).split(idTitleSeparator).last;

  static Future<void> ensureDownloadFolderExist() async {
    final dir = Directory(await absoluteLecturesDownloadsPath);
    return dir.createSync(recursive: true);
  }

  static String lectureFilename(Lecture lecture) =>
      '${lecture.id}$idTitleSeparator${lecture.title}.mp3';

  static Future<String> completeLecturePath(Lecture lecture) async =>
      '${await absoluteLecturesDownloadsPath}${lectureFilename(lecture)}';
}
