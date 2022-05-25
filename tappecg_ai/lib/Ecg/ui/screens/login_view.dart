
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tappecg_ai/Ecg/provider/login_form_provider.dart';
import 'package:tappecg_ai/Ecg/repository/user_repository.dart';
import 'package:tappecg_ai/widgets/home.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _passwordVissible=true;
  void _toggle(){
    setState(() {
      _passwordVissible=!_passwordVissible;
    });
  }
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final userRepository = UserRepository();

  Future<void> login(String email, String password) async {

    if (await userRepository.loginRequest(email,password) == "success") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Home()));
    }

  }
   @override
  Widget build(BuildContext context) {
    final loginForm =Provider.of<LoginFormProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height:MediaQuery.of(context).size.height*0.20,
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width*0.30,
                    width: MediaQuery.of(context).size.width*0.30,
                    child: const FittedBox( child: Image(
                      image: AssetImage("assets/logo.png"),
                    ),
                        fit:BoxFit.fill),
                  ),
                ),
              ),
              const Text(
                'Bienvenido',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25,
                    color: Color(0xFF4881B9)
                    ),
                    
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                decoration: const InputDecoration(
                  hintText: 'Email'
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                obscureText: _passwordVissible,
                controller: passwordController,
                
                decoration: InputDecoration(
                    hintText: 'Password',
                    suffix: IconButton(icon: const Icon(Icons.remove_red_eye), 
                    onPressed:()=>_toggle() ,)
                ),
                
        
              ),
              const SizedBox(height: 40,),
              GestureDetector(
                onTap: (){
                  loginForm.isLoading=true;
                  login(emailController.text.toString(), passwordController.text.toString());
                },
                child: loginForm.isLoading? const CircularProgressIndicator( color: Colors.blue,):Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4881B9),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(child: Text(
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
      ),
    );
  }


}


