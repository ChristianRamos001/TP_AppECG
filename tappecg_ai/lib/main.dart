//import 'dart:html';
import 'dart:convert';
import 'dart:developer' as devlog;
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:tappecg_ai/widgets/home.dart';
import 'package:workmanager/workmanager.dart';
import 'package:tappecg_ai/local_notification.dart';
import 'package:http/http.dart' as http;

void updateCredentials() {
  http.put(
    Uri.parse(
        'https://app-api-ai-heart-mt-prod-eu2-01.azurewebsites.net/api/Notifications/installations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "installationId": "string",
      "platform": "string",
      "pushChannel": "string",
      "tags": "string",
    }),
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //NotificationService().initNotification();
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
