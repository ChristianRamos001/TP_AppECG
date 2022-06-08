import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'package:tappecg_ai/Ecg/provider/login_form_provider.dart';
import 'package:tappecg_ai/Ecg/ui/screens/login_view.dart';
import 'package:tappecg_ai/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(AppState()));
}

class AppState extends StatefulWidget {
  AppState({Key? key}) : super(key: key);

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginFormProvider())],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String? aux = await prefs.getString('token');
      String? aux1 = await prefs.getString('email');
      String? aux2 = await prefs.getString('name');
      UserHelper.token = await aux;
      UserHelper.email = await aux1;
      UserHelper.name = await aux2;
      return await "succes";
    }
    return await "null";
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
              if (snapshot.hasData) {
                if (snapshot.data == "succes") {
                  return const Home();
                } else {
                  return LoginView();
                }
              } else {
                return LoginView();
              }
            }),
        navigatorKey: navigatorKey);
  }
}
