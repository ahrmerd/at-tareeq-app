import 'dart:io';

import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:path_provider/path_provider.dart';

class Logger {
  static Future<void> log(String message) async {
    final logMessage = '[${formatDateTime(DateTime.now())}: $message] \r\n ';
    File(await getLogPath()).writeAsString(logMessage, mode: FileMode.append);
  }

  static Future<List<String>> readLog() async {
    return await (File(await getLogPath()).readAsLines());
  }

  static Future<String> getLogPath() async {
    return '${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}attareeklogs';
  }

  static clearLog() async {
    await (File(await getLogPath())).writeAsString('');
  }
}
