import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/ui/screens/navbar.dart';
import 'package:tappecg_ai/constants.dart';
import 'package:tappecg_ai/widgets/custom_app_bar.dart';

import 'login_view.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            width: double.infinity,
            height: 100.0,
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Registro de Paciente",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Proporcione los datos para ingresar a la app",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Correo'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Nombre'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Apellido materno'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Apellido paterno'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Fecha de nacimiento'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'DNI'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {openDialog();},
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Color(0xFF4881B9),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(
                  'Continuar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (Context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text("Su usuario ha sido creado satisfactoriamente",
                textAlign: TextAlign.center,
                style: TextStyle(color: primaryColor)),
          ),
          SizedBox(
            height: 10,
          ),
          Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF4881B9)
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (BuildContext context) => LoginView()));
                  },
                  child: const Text('Continuar'),
                ),
              ]),
        ],
      ),
    ),
  );
}
