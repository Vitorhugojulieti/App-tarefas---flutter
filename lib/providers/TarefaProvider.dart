import 'package:flutter/foundation.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/intl.dart';
import '../models/Tarefa.dart';
import '../classes/ServicoSessao.dart';
import 'package:dio/dio.dart';

class Tarefaprovider with ChangeNotifier {
  List<Tarefa> tarefas = [];
  Map<DateTime, List<Tarefa>> tarefasAgrupadas = {};
  List<Tarefa> tarefasAgrupadasDia = [];
  //Map<DateTime,List<Tarefa>> tarefasAgrupadasNconcluidas ={};
  DateTime diaSelecionado = DateTime.now();
  bool isLoading = false;

  void carregarTarefas({required String concluido}) async {
    final dio = Dio();
    final int? idUsuario = await Servicosessao().getUsuarioLogado();
    final formato = DateFormat('yyyy-MM-dd');

    isLoading = true;
    tarefasAgrupadas.clear();
    tarefasAgrupadasDia.clear();
    tarefas.clear();
    notifyListeners();

    try {
      final response = await dio.get(
        'https://oracleapex.com/ords/vitor_space/Tarefas/tarefas/?idusuario=${idUsuario}&concluido=${concluido}',
      );
      final listaResponse = response.data['items'];
      for (var t in listaResponse) {
        // debugPrint('aqui');
        if (t['idtarefa'] != null &&
            t['descricao'] != null &&
            t['hora'] != null &&
            t['data_tarefa'] != null &&
            t['concluido'] != null &&
            t['idusuario'] != null) {
          Tarefa tarefa = Tarefa(
            id: t['idtarefa'],
            descricao: t['descricao'],
            data: formato.parse(t['data_tarefa']),
            hora: t['hora'],
          );
          tarefa.concluido = t['concluido'] == "S" ? true : false;
          tarefa.idUsuario = t['idusuario'];
          tarefas.add(tarefa);
        }
      }
      tarefasAgrupadas = agrupaTarefas(tarefas);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void filtraPorDia(DateTime dia) {
    diaSelecionado = dia;
    tarefasAgrupadasDia = tarefasAgrupadas[dia] ?? [];
    notifyListeners();
  }

  Map<DateTime, List<Tarefa>> agrupaTarefas(List<Tarefa> tr) {
    Map<DateTime, List<Tarefa>> grupos = {};

    tr.forEach((tarefa) {
      if (!grupos.containsKey(tarefa.data)) {
        grupos[tarefa.data] = [];
      }

      grupos[tarefa.data]!.add(tarefa);
    });
    return grupos;
  }

  List<Tarefa> get tarefasNaoConcluidas {
    return tarefas.where((tarefa) => tarefa.concluido == false).toList();
  }

  List<Tarefa> get tarefasConcluidas {
    return tarefas.where((tarefa) => tarefa.concluido == true).toList();
  }

  Future<bool> addTarefa(Tarefa tarefa) async {
    final int? idUsuario = await Servicosessao().getUsuarioLogado();
    final dio = Dio();

    try {
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/tarefas/',
        data: {
          "operacao": "I",
          "idusuario": idUsuario,
          "descricao": tarefa.descricao,
          "data_tarefa": DateFormat('yyyy-MM-dd').format(tarefa.data),
          "hora": tarefa.hora,
          "idusuario": idUsuario,
        },
      );
      debugPrint(response.data.toString());
      if (response.data['retorno'] == 'sucesso') {
        //tarefas.add(tarefa);
        if (tarefasAgrupadas[tarefa.data] != null) {
          tarefasAgrupadas[tarefa.data]!.add(tarefa);
        } else {
          final List<Tarefa> lista = [tarefa];
          tarefasAgrupadas[tarefa.data] = lista;
        }
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> onCheck(int idTarefa) async {
    final dio = Dio();
    Tarefa? tarefa = tarefas.firstWhere((tarefa) => tarefa.id == idTarefa);
    DateTime dia = tarefa.data;
    //debugPrint(tarefa.toString());
    try {
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/tarefas/',
        data: {
          "operacao": "U",
          "idTarefa": idTarefa,
          "concluido": !tarefa.concluido == false ? 'N' : 'S',
        },
      );

      if (response.data['retorno'] == 'sucesso') {
        tarefas.removeWhere((tarefa) => tarefa.id == idTarefa);
        tarefasAgrupadas = agrupaTarefas(tarefas);
        tarefasAgrupadasDia = tarefasAgrupadas[dia] ?? [];
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> onDelete(int idTarefa) async {
    final dio = Dio();
    Tarefa? tarefa = tarefas.firstWhere((tarefa) => tarefa.id == idTarefa);
    DateTime dia = tarefa.data;

    try {
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/tarefas/',
        data: {"operacao": "D", "idTarefa": idTarefa},
      );

      if (response.data['retorno'] == 'sucesso') {
        tarefas.removeWhere((tarefa) => tarefa.id == idTarefa);
        tarefasAgrupadas = agrupaTarefas(tarefas);
        tarefasAgrupadasDia = tarefasAgrupadas[dia] ?? [];
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
