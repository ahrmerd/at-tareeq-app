import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' show DateFormat;

T tryCast<T>(dynamic x, {required T fallback}) {
  try {
    return x as T;
  } on TypeError {
    return fallback;
  }
}

String dateTimeFormater(DateTime date) {
  return DateFormat("h:mm a, d, MMM, yyyy").format(date);
}

T tryMapCast<T>({dynamic map, dynamic key, required T fallback}) {
  try {
    final map2 = tryCast(map, fallback: {});
    if (map2.containsKey(key)) {
      return map2[key] as T;
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
    return (await deviceInfo.iosInfo).utsname.machine ?? 'unknown';
  } else if (Platform.isLinux) {
    return (await deviceInfo.linuxInfo).prettyName;
  } else if (Platform.isWindows) {
    return (await deviceInfo.windowsInfo).computerName;
  } else {
    return 'unknownDevice';
  }
}

Future<String?> getStorageDirectory(String folder) async {
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
    // try {
    return int.parse(val);
    // } catch (e) {
    // return 0;
    // }
  } else {
    return 0;
  }
}
