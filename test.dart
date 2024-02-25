import 'package:flutter/foundation.dart';

void main() {
  String inputString = "https://example.com/";

// Remove trailing '/'
  String resultString = inputString.replaceAll(RegExp(r'\/$'), '');

  if (kDebugMode) {
    print(resultString);
  }

  if (kDebugMode) {
    print(removeTrailing(inputString, '/'));
  }

//   var myColor = Color(0xff2c195c);
//   print ('red: ${myColor.red} green: ${myColor.green} blue: ${myColor.blue}');
//   for (int i = 0; i < 5; i++) {
//     print('hello ${i + 1}');
//   }
}

String removeTrailing(String source, String pattern) {
  if (pattern.isEmpty) return source;
  while (source.endsWith(pattern)) {
    source = source.substring(0, source.length - pattern.length);
  }
  return source;
}
