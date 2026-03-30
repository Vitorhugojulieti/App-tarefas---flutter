import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../classes/ServicoSessao.dart';
import '../models/Usuario.dart';
import 'package:flutter/material.dart';

class Usuarioprovider with ChangeNotifier {
  String email = '';
  int totalTarefasConcluidas = 0;
  int totalTarefasPendentes = 0;

  Future<bool> login(String email, String senha) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/login/',
        data: {"email": email, "senha": senha},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (response.data['idusuario'] != null) {
        new Servicosessao().salvarSessao(response.data['idusuario']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> cadastrar(String email, String senha) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/cadastro/',
        data: {"email": email, "senha": senha},
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      if (response.data['retorno'] == 'sucesso') {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> carregarDados() async {
    try {
      int? idUsuario = await Servicosessao().getUsuarioLogado();
      final dio = new Dio();
      final response = await dio.get(
        'https://oracleapex.com/ords/vitor_space/Tarefas/usuario/?idusuario=${idUsuario}',
      );
      final dados = response.data['items'][0];
      if (dados['email'] != null &&
          dados['tarefas_concluidas'] != null &&
          dados['tarefas_pendentes'] != null) {
        this.email = dados['email'];
        this.totalTarefasConcluidas = dados['tarefas_concluidas'];
        this.totalTarefasPendentes = dados['tarefas_pendentes'];
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> alterarSenha(String senha) async {
    try {
      int? idUsuario = await Servicosessao().getUsuarioLogado();
      final dio = Dio();
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/usuario/',
        data: {"idusuario": idUsuario, "senha": senha},
      );

      if (response.data['retorno'] == 'sucesso') {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
