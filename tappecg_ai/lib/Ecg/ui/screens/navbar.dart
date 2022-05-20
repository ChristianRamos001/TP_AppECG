import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappecg_ai/Ecg/ui/screens/faq.dart';
import 'package:tappecg_ai/Ecg/ui/screens/login_view.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:tappecg_ai/widgets/home.dart';
import 'package:tappecg_ai/Ecg/ui/screens/hospitals_view.dart';

class NavBar extends StatelessWidget {
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
          accountName: Text('Hola,'),
          accountEmail: Text('Washer'),
          currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  child: Image(
            image: AssetImage("assets/logo.png"),
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          )))),
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Home()));
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Preguntas Frecuentes'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Faq()));
        },
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.notifications),
        title: Text('Visualizar Mèdicos Asignados'),
        onTap: () {},
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.local_hospital),
        title: Text('Visualizar Centros de Salud'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Hospital()));
        },
      ),
      Divider(),
      ListTile(
          leading: Icon(Icons.subdirectory_arrow_left),
          title: Text('Cerrar sesión'),
          onTap: () {
            removeToken().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginView())));
          })
    ]));
  }
}
