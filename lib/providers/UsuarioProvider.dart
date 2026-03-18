import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../classes/ServicoSessao.dart';
import '../models/Usuario.dart';
import 'package:flutter/material.dart';

class Usuarioprovider with ChangeNotifier{
  Future<bool> login(String email, String senha)async{
    final dio = Dio();
    try{
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/login/',
        data: {
          "email":email,
          "senha":senha
        },
        options: Options(
          headers: {
            "Content-Type": "application/json"
          }
        ),
      );
      if(response.data['idusuario'] != null ){
        new Servicosessao().salvarSessao(response.data['idusuario']);
        return true;
      }
      return false;
    }catch (e){
      return false;
    }
  }

  Future<bool> cadastrar(String email, String senha)async{
    final dio = Dio();
    try{
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/cadastro/',
        data: {
          "email":email,
          "senha":senha
        },
        options: Options(
          headers: {
            "Content-Type": "application/json"
          }
        ),
      );
      if(response.data['retorno'] == 'sucesso'){
        return true;
      }
      return false;
    }catch (e){
      return false;
    }
  }
}