import 'package:flutter/material.dart';
import '../models/Subtarefa.dart';

class SubtarefaComponent extends StatelessWidget{
  SubtarefaComponent(this.subtarefa);
  Subtarefa subtarefa;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Radio(value: subtarefa.concluido),
          Expanded(
            child:Text(subtarefa.descricao) ,
          ),
          IconButton(
              onPressed: null,
              icon: Icon(Icons.cancel,color: Colors.red),
          ),
        ],
      ),
    );
  }
}