import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'package:tappecg_ai/Ecg/provider/login_form_provider.dart';
import 'package:tappecg_ai/Ecg/ui/screens/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tappecg_ai/Ecg/services/notification_action_service.dart';

final notificationActionService = NotificationActionService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppState());
}

class AppState extends StatefulWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginFormProvider())],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String? aux = prefs.getString('token');
      UserHelper.token = aux;
      UserHelper.Introviewed = (prefs.getBool('introviewed'))!;
      return "succes";
    }
    return "null";
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String>(
          future: getToken(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              if (snapshot.data == "succes") {
                return const Home();
              } else {
                return const LoginView();
              }
<<<<<<< Updated upstream
            }
            else {
              return LoginView();
=======
            } else {
              return const LoginView();
>>>>>>> Stashed changes
            }

          }),
    );
  }
}
