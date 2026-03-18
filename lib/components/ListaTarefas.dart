import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import 'package:provider/provider.dart';
import '../models/Tarefa.dart';
import '../components/TarefaComponent.dart';
import 'package:intl/intl.dart';



class Listatarefas extends StatelessWidget{
  Listatarefas(this.tarefas,this.tipoListagem);
  final List<Tarefa>? tarefas;
  String tipoListagem;
  
  @override
  Widget build(BuildContext context){

    if(tipoListagem == 'N'){

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
            itemCount:this.tarefas!.length, //datas.length,//this.tarefas.length,
            itemBuilder: (ctx,index){
              final tr = this.tarefas![index];
              return Column(
                children: [
                  Text(
                    'Tarefas do dia: ${DateFormat('dd/MM/yyyy').format(context.read<Tarefaprovider>().diaSelecionado)}'
                  ),
                  SizedBox(height: 10),
                  Tarefacomponent(tr)
                ],
              );
            },
          ),
        );
    }else{
      final provider = context.watch<Tarefaprovider>();
      final datas = provider.tarefasAgrupadas.keys.toList()..sort();
      return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: ListView.builder(
            itemCount:provider.tarefasAgrupadas.length, //datas.length,//this.tarefas.length,
            itemBuilder: (ctx,index){
               final data = datas[index];
               final tarefas = provider.tarefasAgrupadas[data]!;
   

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat('dd-MM-yyyy').format(data)),
                    ...tarefas.map((tarefa){
                      return Tarefacomponent(tarefa);
                    }).toList(),
                  ],

                ); 
            },
          ),
        );
    }
  }
}

// 1- criar componente tarefa separado da listagem ---------- ok
// 2- criar processo dentro do provider para carregar e trazer listagem agrupada
// 3- criar processo no provider para trazer lista de datas
// 4- atualizar listagem de forma agrupada