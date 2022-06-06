import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tappecg_ai/Ecg/model/user.dart';
import 'package:tappecg_ai/Ecg/provider/login_form_provider.dart';
import 'package:tappecg_ai/Ecg/repository/user_repository.dart';
import 'package:tappecg_ai/Ecg/ui/screens/reset_password.dart';
import 'package:tappecg_ai/main.dart';
import 'package:tappecg_ai/widgets/home.dart';

import '../../../constants.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordVissible = true;
  bool passwordIsValid = true;
  void _toggle() {
    setState(() {
      _passwordVissible = !_passwordVissible;
    });
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final userRepository = UserRepository();

  Future<void> login(String email, String password) async {
    if (await userRepository.loginRequest(email, password) == "success") {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const Home(),
        ),
      );
    } else {
      setState(() {
        passwordIsValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.10,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.20,
                    child: FittedBox(
                        child: Image(
                          image: AssetImage("assets/logo.png"),
                        ),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Text(
                'Bienvenido',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF4881B9)),
              ),
              (passwordIsValid)
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        'Por favor, ingrese una contraseña para continuar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Text(
                        'El usuario o contraseña ingresados son incorrectos o no existen',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.red),
                      ),
                    ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.perm_contact_cal_rounded),
                      onPressed: () {},
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email'),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _passwordVissible,
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.lock),
                      onPressed: () {},
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () => _toggle(),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ResetPassword()));
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  loginForm.isLoading = true;
                  login(emailController.text.toString(),
                          passwordController.text.toString())
                      .then(
                    (value) => setState(() {
                      loginForm.isLoading = false;
                    }),
                  );
                },
                child: loginForm.isLoading
                    ? CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Color(0xFF4881B9),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Ingresar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
