import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_task/model/task.dart';
import 'package:my_task/screens/task_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(TaskAdapter());
  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  await Hive.openBox('myBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskScreen(),
    );
  }
}
