import 'package:flutter/material.dart';
import 'package:projeto_despesas/models/Subtarefa.dart';
import 'package:dio/dio.dart';
import '../models/Subtarefa.dart';
import '../providers/TarefaProvider.dart';
import 'package:provider/provider.dart';

class Subtarefaprovider with ChangeNotifier {
  List<Subtarefa> subtarefas = [];
  bool isLoading = false;
  double porcentagem = 0;


  void carregarSubtarefas({required int idtarefa}) async {
    isLoading = true;
    subtarefas.clear();
    notifyListeners();

    try {
      final dio = Dio();
      final response = await dio.get(
        'https://oracleapex.com/ords/vitor_space/Tarefas/subtarefas/?idtarefa=${idtarefa}',
      );

      final lista = response.data['items'];
      for (var s in lista) {
        subtarefas.add(
          new Subtarefa(
            descricao: s['descricao'],
            concluido: s['concluido'] == 'S' ? true : false,
            idTarefa: s['idtarefa'],
            id: s['idsubtarefa'],
          ),
        );
      }
      isLoading = false;
              // porcentagem 
      if (subtarefas.isNotEmpty) {
        porcentagem =
            (totalSubtarefasConcluidas * 100) /
            subtarefas.length;
      } else {
        porcentagem = 0;
        }
      notifyListeners();
      debugPrint(subtarefas.toString());
      
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> addSubtarefa(BuildContext context,Subtarefa subtarefa) async {
    try {
      final dio = new Dio();
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/subtarefas/',
        data: {
          "operacao": "I",
          "idTarefa": subtarefa.idTarefa,
          "descricao": subtarefa.descricao,
        },
      );

      if (response.data['retorno'] == 'sucesso') {
        subtarefas.add(subtarefa);
        calculaPorcentagem();
        context.read<Tarefaprovider>().atualizaPorcentagem(subtarefa.idTarefa,porcentagem.toInt());
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeSubtarefa(BuildContext context, int idSubtarefa) async {
    final Subtarefa subtarefa = subtarefas.firstWhere((sub) => sub.id == idSubtarefa);
    try {
      final dio = new Dio();
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/subtarefas/',
        data: {"operacao": "D", "idSubTarefa": idSubtarefa},
      );

      if (response.data['retorno'] == 'sucesso') {
        subtarefas.removeWhere((sub) => sub.id == idSubtarefa);
        calculaPorcentagem();
        context.read<Tarefaprovider>().atualizaPorcentagem(subtarefa.idTarefa,porcentagem.toInt());
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkSubtarefa(BuildContext context,int idSubtarefa) async {
    final Subtarefa subtarefa = subtarefas.firstWhere((sub) => sub.id == idSubtarefa);
    try {
      final dio = new Dio();
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/subtarefas/',
        data: {
          "operacao": "U", 
          "idSubTarefa": idSubtarefa,
          "concluido":!subtarefa.concluido == false ? 'N' : 'S'  
        },
      );

      if (response.data['retorno'] == 'sucesso') {
        subtarefa.concluido = !subtarefa.concluido;
        calculaPorcentagem();
        context.read<Tarefaprovider>().atualizaPorcentagem(subtarefa.idTarefa,porcentagem.toInt());
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  int get totalSubtarefasConcluidas{
    return subtarefas.where((sub) => sub.concluido).length;
  }

  void calculaPorcentagem(){
    if (subtarefas.isNotEmpty) {
      porcentagem =
          (totalSubtarefasConcluidas * 100) /
          subtarefas.length;
    } else {
      porcentagem = 0;
    }

    if(porcentagem == 100){
     //concluir a tarefa
     // context.read<Tarefaprovider>().atualizaPorcentagem(subtarefa.idTarefa,porcentagem.toInt());
    }
  }
}
