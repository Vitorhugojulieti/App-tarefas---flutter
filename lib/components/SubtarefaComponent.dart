import 'package:flutter/material.dart';
import '../models/Subtarefa.dart';
import 'package:provider/provider.dart';
import '../providers/SubtarefaProvider.dart';
import '../providers/TarefaProvider.dart';

class SubtarefaComponent extends StatelessWidget {
  SubtarefaComponent(this.subtarefa, this.tarefaConcluida);
  Subtarefa subtarefa;
  bool tarefaConcluida;

  _removeSubTarefa(BuildContext context, int idSubtarefa) async {
    final bool retorno = await context
        .read<Subtarefaprovider>()
        .removeSubtarefa(context, idSubtarefa);

    if (retorno) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Subtarfa removida com sucesso!',
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.greenAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao remover subtarefa!',
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  _checkSubTarefa(BuildContext context, int idSubtarefa) async {
    if (tarefaConcluida) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'A tarefa ja foi concluida!',
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      final provider = context.read<Subtarefaprovider>();
      final bool retorno = await provider.checkSubtarefa(context, idSubtarefa);

      if (retorno) {
        if (provider.porcentagem.toInt() == 100) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tarefa concluida com sucesso!',
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
              backgroundColor: Colors.greenAccent,
            ),
          );
          Navigator.pop(context);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Subtarfa concluida com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.greenAccent,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao concluir subtarefa!',
              style: TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Checkbox(
            value: subtarefa.concluido,
            onChanged: (value) {
              _checkSubTarefa(context, subtarefa.id);
            },
          ),
          Expanded(child: Text(subtarefa.descricao)),
          tarefaConcluida
              ? SizedBox(width: 10)
              : IconButton(
                  onPressed: () {
                    _removeSubTarefa(context, subtarefa.id);
                  },
                  icon: Icon(Icons.cancel, color: Colors.red),
                ),
        ],
      ),
    );
  }
}
