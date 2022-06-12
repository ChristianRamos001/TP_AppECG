import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'package:tappecg_ai/Ecg/ui/screens/doctors_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/faq.dart';
import 'package:tappecg_ai/Ecg/ui/screens/login_view.dart';
import 'package:tappecg_ai/Ecg/ui/screens/test.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:tappecg_ai/widgets/home.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (Context) => AlertDialog(
          title: Text("¿Estas Seguro que desea cerrar sesión?",
              style: TextStyle(color: primaryColor)),
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF4881B9),
                  ),
                  onPressed: () {
                    removeToken().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginView())));
                  },
                  child: const Text('Aceptar'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ]),
        ),
      );

  var name;

  Future<void> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var aux = await prefs.getString('name');
    setState(() {
      name = aux;
    });
  }

  @override
  void initState() {
    name = getName();
    super.initState();
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
          accountEmail:
              UserHelper.name != null ? Text(name.toString()) : Text(''),
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
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Centro de Salud'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ActivityRecognitionApp()));
        },
      ),
      ListTile(
        leading: Icon(Icons.notifications),
        title: Text('Visualizar Mèdicos Asignados'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => DoctorView()));
        },
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Test'),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ActivityRecognitionApp()));
        },
      ),
      ListTile(
          leading: Icon(Icons.subdirectory_arrow_left),
          title: Text('Cerrar sesión'),
          onTap: () {
            openDialog();
          })
    ]));
  }
}
