import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../classes/ServicoSessao.dart';

class Usuario {
  int id = 0;
  String? email = '';
  String? senha = '';

  Usuario({this.email,this.senha});

  Future<bool> validaLogin() async{
    final dio = Dio();
    debugPrint(this.email);
    debugPrint(this.senha);
    try{
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/login/',
        data: {
          "email":this.email,
          "senha":this.senha
        },
        options: Options(
          headers: {
            "Content-Type": "application/json"
          }
        ),
      );
      //debugPrint(response.data.toString());
      if(response.data['idusuario'] != null ){
        new Servicosessao().salvarSessao(response.data['idusuario']);
        return true;
      }
      return false;
    }catch (e){
      return false;
    }
  }


}

