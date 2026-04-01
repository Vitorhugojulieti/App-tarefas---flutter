import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_despesas/classes/ServicoNotificacao.dart';
import 'package:provider/provider.dart';
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
        if (t['idtarefa'] != null &&
            t['descricao'] != null &&
            t['hora'] != null &&
            t['data_tarefa'] != null &&
            t['concluido'] != null ) {
          // hora
          // final horaMinuto = t['hora'].toString().split(':');
          // final TimeOfDay horaNotificacao = new TimeOfDay(hour: int.parse(horaMinuto[0]), minute: int.parse(horaMinuto[0])); 
          final data = formato.parse(t['data_tarefa']);
          // // debugPrint(data.toString());
          // DateTime dataNotificacao = DateTime(
          //  data.year,
          //  data.month,
          //  data.day,
          //  horaNotificacao.hour,
          //  horaNotificacao.minute
          // );    
          Tarefa tarefa = Tarefa(
            id: t['idtarefa'],
            descricao: t['descricao'],
            data: data,
            hora: t['hora'],
            porcentagemConcluida:t['porcentagem'] ?? 0,
            dataNotificacao: DateTime.now()
          );

          tarefa.concluido = t['concluido'] == "S" ? true : false;
          tarefa.idUsuario = t['idusuario'];
          tarefas.add(tarefa);
        }else{
         debugPrint(t['idtarefa'].toString());
        }
      }
      tarefasAgrupadas = agrupaTarefas(tarefas);
      DateTime hoje = DateTime.now();
      filtraPorDia(DateTime(
        hoje.year,
        hoje.month,
        hoje.day
      ));
      isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void filtraPorDia(DateTime dia) {
    debugPrint(tarefasAgrupadas.toString());
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

  Future<bool> addTarefa(BuildContext context, Tarefa tarefa) async {
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
          "hora": tarefa.hora // DateFormat('HH:mm').format(tarefa.data),
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
        debugPrint('Data no provider: ${tarefa.data}');
        // criar notificacao
        notifyListeners();

        context.read<ServicoNotificacao>().agendarNotificacao(context,tarefa);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> onCheck(int idTarefa) async {
    try {
      final dio = Dio();
      Tarefa? tarefa = tarefas.firstWhere((tarefa) => tarefa.id == idTarefa);
      DateTime dia = tarefa.data;
      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/tarefas/',
        data: {
          "operacao": "C",
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

  Future<bool> atualizaTarefa(Tarefa tarefa)async{
     try {
      final dio = Dio();

      final response = await dio.post(
        'https://oracleapex.com/ords/vitor_space/Tarefas/tarefas/',
        data: {
          "operacao": "U",
          "idTarefa": tarefa.id,
          "concluido": tarefa.concluido == false ? 'N' : 'S',
          "descricao":tarefa.descricao,
          "data_tarefa": DateFormat('yyyy-MM-dd').format(tarefa.data),
          "hora":DateFormat('HH:mm').format(tarefa.data),
          "porcentagem":tarefa.porcentagemConcluida
        },
      );
      debugPrint(response.toString());
      if (response.data['retorno'] == 'sucesso') {
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void atualizaPorcentagem(int idTarefa, int porcentagem){
    debugPrint(porcentagem.toString());

    Tarefa? tarefa = tarefas.firstWhere((tr)=> tr.id == idTarefa);
    tarefa.porcentagemConcluida = porcentagem;
    debugPrint(porcentagem.toString());
    notifyListeners();
  }
}
