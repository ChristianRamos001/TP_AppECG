import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tappecg_ai/Ecg/ui/screens/faq.dart';
import 'package:tappecg_ai/Ecg/ui/screens/login_view.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:tappecg_ai/widgets/home.dart';

class NavBar extends StatelessWidget {
  Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color:primaryColor,
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
        leading: const Icon(Icons.home),
        title: const Text('Home'),
        onTap: () {
<<<<<<< Updated upstream
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home()));
        },
      ),
=======
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => const Home()));
        },
      ),
      const Divider(),
>>>>>>> Stashed changes
      ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Preguntas Frecuentes'),
        onTap: () {
<<<<<<< Updated upstream
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Faq()));
=======
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => const Faq()));
>>>>>>> Stashed changes
        },
      ),
      const Divider(),
      ListTile(
<<<<<<< Updated upstream
        leading: Icon(Icons.notifications),
        title: Text('Visualizar Mèdicos Asignados'),
        onTap: () {

        },
      ),

      Divider(),
=======
        leading: const Icon(Icons.notifications),
        title: const Text('Visualizar Mèdicos Asignados'),
        onTap: () {},
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.local_hospital),
        title: const Text('Visualizar Centros de Salud'),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => const Hospital()));
        },
      ),
      const Divider(),
>>>>>>> Stashed changes
      ListTile(
          leading: const Icon(Icons.subdirectory_arrow_left),
          title: const Text('Cerrar sesión'),
          onTap: () {
            removeToken().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
<<<<<<< Updated upstream
                    builder: (BuildContext context) => LoginView())
            ));

=======
                    builder: (BuildContext context) => const LoginView())));
>>>>>>> Stashed changes
          })
    ]));
  }
}
