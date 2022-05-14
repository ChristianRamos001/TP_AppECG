import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tappecg_ai/Ecg/provider/login_form_provider.dart';
import 'package:tappecg_ai/Ecg/ui/screens/login_view.dart';
import 'package:tappecg_ai/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp( AppState());
}
class AppState extends StatefulWidget {
  AppState({Key? key}) : super(key: key);

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {

  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [ ChangeNotifierProvider(create: (_)=> LoginFormProvider()) ],
    child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {

    
  Future<bool>getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? aux = await prefs.getString('apiToken');  
    if (aux != null){
      return true;
    }
    return false;
  }

  bool isLogin(){
    bool token = false;

    getToken().then((value) => token = value);

    return token;
  }
  const MyApp({Key? key}) : super(key: key);
  
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isLogin() != true ? const LoginView() : const Home() );
  }
}
