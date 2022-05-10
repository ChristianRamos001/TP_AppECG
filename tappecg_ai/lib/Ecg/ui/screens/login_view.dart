import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'package:tappecg_ai/Ecg/repository/user_repository.dart';
import 'package:tappecg_ai/main.dart';
import 'package:tappecg_ai/widgets/home.dart';

import '../../../constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

    
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final userRepository = UserRepository();

  Future<void> login(String email, String password) async {

    if (await userRepository.loginRequest(email,password) == "success") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home()));
    }

  }
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
        child: Column(
          children: [
            Container(
              height:MediaQuery.of(context).size.height*0.20,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.width*0.30,
                  width: MediaQuery.of(context).size.width*0.30,
                  child: FittedBox( child: Image(
                    image: AssetImage("assets/logo.png"),
                  ),
                      fit:BoxFit.fill),
                ),
              ),
            ),
            Text(
              'Bienvenido',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25,
                  color: Color(0xFF4881B9)
                  ),
                  
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Text(
              'Por favor, ingrese una contraseña para continuar',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15,
                  color: Colors.grey
                  ),
                  
            ),
            ),            
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email'
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Password'
              ),
            ),
            SizedBox(height: 40,),
            GestureDetector(
              onTap: (){
                login(emailController.text.toString(), passwordController.text.toString());
              },
              child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                  color: Color(0xFF4881B9),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text(
                  'Ingresar',
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),),
              ),
            )
          ],
        ),
      ),
    );
  }


}


