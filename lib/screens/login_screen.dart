import 'package:flutter/material.dart';
import '../components/FormLogin.dart';
import '../models/Usuario.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // pesquisar o q é esse key
  

  @override
  State<LoginScreen> createState() => _LoginScreenState(); 
}

class _LoginScreenState extends State<LoginScreen>{

  @override
  Widget build(BuildContext context){ //metodo obrigatorio
    return Scaffold(
      body:Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary
              ]
            ),
          ),
          child:  Align(
            alignment: Alignment.bottomCenter,
          child: Formlogin(),
        ),
      ),
    );
  }
}