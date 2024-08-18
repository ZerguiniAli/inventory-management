import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:window_manager/window_manager.dart';
import 'package:zing/pages/login.dart';
import 'package:flutter/services.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();

   if (Platform.isWindows) {
     await windowManager.ensureInitialized();
     await windowManager.setFullScreen(true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}