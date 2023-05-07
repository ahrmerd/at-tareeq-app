import 'package:at_tareeq/app/my_app.dart';
import 'package:flutter/material.dart';

import 'app/dependancies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dependancies.init();
  runApp(const MyApp());
}
