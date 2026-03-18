import 'package:flutter/material.dart';
import '../components/FormCadastro.dart';

class CadastroScreen extends StatefulWidget{
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreen();
}


class _CadastroScreen extends State<CadastroScreen>{

  @override
  Widget build(BuildContext context){
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
        child: Align(
          alignment: Alignment.bottomCenter,
          child:  FormCadastro(),
        ),
      ),
    );
  }
}