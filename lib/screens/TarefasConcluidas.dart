import 'package:flutter/material.dart';
import '../components/ListaTarefas.dart';
import 'package:provider/provider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';


class Tarefasconcluidas extends StatefulWidget{
  const Tarefasconcluidas();
  //final Map<DateTime,List<Tarefa>> grupos;
  @override
  State<Tarefasconcluidas> createState()=> _Tarefasconcluidas();
}

class _Tarefasconcluidas extends State<Tarefasconcluidas>{
    @override
  void initState(){
    super.initState();
    //final provider = Provider.of<Tarefaprovider>(context,listen: false);
    Future.microtask((){
      //provider.carregarTarefasConcluidas();
      context.read<Tarefaprovider>().carregarTarefas(concluido: 'S'); //executa função do provider sem escutar mudanças
    });
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<Tarefaprovider>(context,listen: false);
    //provider.carregarTarefasConcluidas();
    final provider = context.watch<Tarefaprovider>();
    return Container(
        padding: EdgeInsetsGeometry.all(10),
        child:Center(
          child: Column(
          children: [
            // SizedBox(height: 10),
            // Text(
            //   'Minhas tarefas',
            //   style: TextStyle(
            //     color: Theme.of(context).primaryColor,
            //     fontSize: 25,
            //     fontWeight: FontWeight.normal
            //   ),
            // ),
            SizedBox(height:20),
            Expanded(
              child:Listatarefas(provider.tarefasAgrupadasDia,'S') 
            ),
            //Text('Total de tarefas: ${tarefas.length}',style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
      );
  }
}