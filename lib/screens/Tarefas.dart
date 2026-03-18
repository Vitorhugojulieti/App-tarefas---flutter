import 'package:flutter/material.dart';
import '../components/ListaTarefas.dart';
import 'package:provider/provider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import '../components/Calendario.dart';


class Tarefas extends StatefulWidget{
  Tarefas();
  //Map<DateTime,List<Tarefa>> tarefas = {};

  @override
  State<Tarefas>  createState()=> _Tarefas();
}

class _Tarefas extends State<Tarefas>{

  @override
  void initState(){
    super.initState();
    //final provider = Provider.of<Tarefaprovider>(context,listen: false);
    Future.microtask((){
      //provider.carregarTarefasNConcluidas();
      context.read<Tarefaprovider>().carregarTarefas(concluido: 'N');
    });
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<Tarefaprovider>(context,listen: false);
    //provider.carregarTarefasNConcluidas();
    final provider = context.watch<Tarefaprovider>();

    return Container(
     // child: Center(
        child:Column(
          children: [
            //CarrocelDias(provider.tarefasAgrupadas.keys.toList()),
            Calendario(),
            SizedBox(height:15),
            Expanded(
              child:Listatarefas(provider.tarefasAgrupadasDia,'N') 
            ),
            Text('Total de tarefas: ${provider.tarefasAgrupadasDia.length}',style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
      ),
 //   ),
    );
  }
}