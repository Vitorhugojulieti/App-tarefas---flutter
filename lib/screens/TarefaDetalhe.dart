import 'package:flutter/material.dart';
import 'package:projeto_despesas/components/SubtarefaComponent.dart';
import 'package:projeto_despesas/models/Subtarefa.dart';
import '../models/Tarefa.dart';

class TarefaDetalhe extends StatefulWidget{
  TarefaDetalhe(this.tarefa);
  Tarefa tarefa;

  @override
  State<TarefaDetalhe> createState() => _TarefaDetalhe();
}

class _TarefaDetalhe extends State<TarefaDetalhe>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe tarefa'),
      ),
      body: Column(
        children: [

          // trocar por um listviewbuilder - carregando as subtarefas
          Column(
            children: [
              SubtarefaComponent(Subtarefa(concluido: false,descricao: 'teste',idTarefa: 1)),
            ],
          )
        ],
      ),
    );
  }
}