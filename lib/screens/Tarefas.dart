import 'package:flutter/material.dart';
import '../components/ListaTarefas.dart';
import 'package:provider/provider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import '../components/Calendario.dart';
import '../models/Tarefa.dart';

class Tarefas extends StatefulWidget {
  Tarefas();
  //Map<DateTime,List<Tarefa>> tarefas = {};

  @override
  State<Tarefas> createState() => _Tarefas();
}

class _Tarefas extends State<Tarefas> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<Tarefaprovider>().carregarTarefas(concluido: 'N');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Tarefaprovider>();

    return provider.isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        : Container(
            child: Column(
              children: [
                Calendario(),
                SizedBox(height: 15),
                Expanded(child: ListaTarefas(provider.tarefasAgrupadasDia)),
                Text(
                  'Total de tarefas: ${provider.tarefasAgrupadasDia.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            
          );
  }
}
