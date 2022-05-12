import 'package:flutter/material.dart';
import 'package:tappecg_ai/widgets/home.dart';

void callbackDispatcher(){
  Workmanager.executeTask((taskName, inputData) async{
  LocalNotification.Initializer();
  LocalNotification.ShowOneTimeNotification(DateTime.now());
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask("test_workertask", "test_workertask",
      frequency:Duration(minutes:15),
      inputData:{"data1":"value1","data2":"value2"});

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
