import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' show DateFormat;

T tryCast<T>(dynamic x, {required T fallback}) {
  try {
    return x as T;
  } on TypeError {
    return fallback;
  }
}

String formatDateTime(DateTime date) {
  return DateFormat("h:mm a, d, MMM, yyyy").format(date);
}

String formatTime(DateTime date) {
  return DateFormat('h:mm a').format(date);
}

String formatDate(DateTime date) {
  return DateFormat('d, MMM, yyyy').format(date);
}

R tryMapCast<R>({required Map? map, dynamic key, required R fallback}) {
  try {
    final map2 = tryCast<Map>(map, fallback: {});
    if (map2.containsKey(key)) {
      return map2[key] as R;
    }
    return fallback;
  } on TypeError {
    return fallback;
  }
}

String getfileBasename(File entity) {
  return entity.path.split(Platform.pathSeparator).last;
}

String getFileNameFromPath(String path) {
  return path.split(Platform.pathSeparator).last;
}

Future<String> getDeviceName() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    return (await deviceInfo.androidInfo).model;
  } else if (Platform.isIOS) {
    return (await deviceInfo.iosInfo).utsname.machine;
  } else if (Platform.isLinux) {
    return (await deviceInfo.linuxInfo).prettyName;
  } else if (Platform.isWindows) {
    return (await deviceInfo.windowsInfo).computerName;
  } else {
    return 'unknownDevice';
  }
}

Future<String?> getStoragePath(String folder) async {
  Directory? dir;
  if (Platform.isAndroid) {
    dir = await getExternalStorageDirectory();
  } else if (Platform.isIOS) {
    dir = await getDownloadsDirectory();
  } else if (Platform.isLinux || Platform.isWindows) {
    dir = await getDownloadsDirectory();
  } else {
    dir = await getDownloadsDirectory();
  }
  if (dir != null) {
    return dir.path + Platform.pathSeparator + folder;
  }
  return null;
}

int dynamicIntParsing(dynamic val) {
  if (val is int) {
    return val;
  } else if (val is String) {
    return int.tryParse(val) ?? 0;
  } else if (val is double) {
    return val.toInt();
  } else {
    return dynamicIntParsing(val.toString());
    // return 0;
  }
}

String extractTextBeforeFullStop(Object input) {
  String stringVal = input.toString();
  int index = stringVal.indexOf('.');
  if (index == -1) {
    return stringVal;
  } else {
    return stringVal.substring(0, index + 1);
  }
}

String formatLength(int seconds) {
  if (seconds < 0) {
    throw ArgumentError("Time cannot be negative.");
  }

  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  String result = '';
  if (hours > 0) {
    result += '$hours hr ';
  }
  if (minutes > 0) {
    result += '$minutes min ';
  }
  if (remainingSeconds > 0) {
    result += '$remainingSeconds secs';
  }

  return result.trim();
}

String formatDuration(Duration duration) {
  // String twoDigits(int n) {
  //   if (n >= 10) return "$n";
  //   return "0$n";
  // }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String twoDigitHours = twoDigits(hours);
  String twoDigitMinutes = twoDigits(minutes);
  String twoDigitSeconds = twoDigits(seconds);

  if (hours > 0) {
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  } else {
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

String fileEntityBasename(FileSystemEntity entity) {
  if (entity is Directory) {
    return entity.path.split(Platform.pathSeparator).last;
  } else if (entity is File) {
    return entity.path.split(Platform.pathSeparator).last;
  } else {
    if (kDebugMode) {
      print(
          "Please provide a Object of type File, Directory or FileSystemEntity");
    }
    return "";
  }
}

String parsePhone(String phone, [String phoneCode = "234"]) {
  phone = phone.trim();
  if (phone.startsWith('+')) {
    return phone;
  } else if (phone.length >= 12) {
    return "+$phone";
  } else if (phone.startsWith('0')) {
    return "+$phoneCode${phone.substring(1)}";
  } else {
    return "+$phoneCode$phone";
  }
}

ScrollController addOnScollFetchMore(VoidCallback dataFetcher) {
  final scrollController = ScrollController();
  scrollController.addListener(() {
    if (kDebugMode) {
      print('scrolling');
    }
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      dataFetcher.call();
    }
  });
  return scrollController;
}


// mixin MyScrollMixin{
//   final ScrollController scroll = ScrollController();

//     MyScrollMixin(){
//     scroll.addListener(_listener);
//     }

//   bool _canFetchBottom = true;

//   bool _canFetchTop = true;

//   void _listener() {
//     if (scroll.position.atEdge) {
//       _checkIfCanLoadMore();
//     }
//   }

//   Future<void> _checkIfCanLoadMore() async {
//     if (scroll.position.pixels == 0) {
//       if (!_canFetchTop) return;
//       _canFetchTop = false;
//       await onTopScroll();
//       _canFetchTop = true;
//     } else {
//       if (!_canFetchBottom) return;
//       _canFetchBottom = false;
//       await onEndScroll();
//       _canFetchBottom = true;
//     }
//   }

//   Future<void> onEndScroll();

//   Future<void> onTopScroll();

//   @override
//   void onClose() {
//     scroll.removeListener(_listener);
//     super.onClose();
//   }
// }



// enum PopupMenuItemActionType { openDialgoue }
