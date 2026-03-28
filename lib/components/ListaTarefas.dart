import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import 'package:provider/provider.dart';
import '../models/Tarefa.dart';
import '../components/TarefaComponent.dart';
import 'package:intl/intl.dart';

class ListaTarefas extends StatelessWidget {
  ListaTarefas(this.tarefas);
  final List<Tarefa>? tarefas;

  @override
  Widget build(BuildContext context) {
    if (tarefas!.isEmpty || tarefas == null) {
      return Center(
        child: Text(
          'Não há tarefas cadastradas',
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView.builder(
        itemCount: this.tarefas!.length, //datas.length,//this.tarefas.length,
        itemBuilder: (ctx, index) {
          final tr = this.tarefas![index];
          return Column(
            children: [
              SizedBox(height: 10),
              Tarefacomponent(tr),
            ],
          );
        },
      ),
    );
  }
}