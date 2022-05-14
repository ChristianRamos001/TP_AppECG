//import 'dart:html';
import 'dart:developer' as devlog;
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:tappecg_ai/widgets/home.dart';
import 'package:workmanager/workmanager.dart';
import 'package:tappecg_ai/local_notification.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}
