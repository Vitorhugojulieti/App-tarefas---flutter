import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import 'package:projeto_despesas/screens/TarefaDetalhe.dart';
import 'package:provider/provider.dart';
import '../models/Tarefa.dart';
import 'package:intl/intl.dart';

class Tarefacomponent extends StatelessWidget {
  Tarefacomponent(this.tr);
  final Tarefa tr;
  _abrirModalAddTarefa(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => TarefaDetalhe(tr),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint(tr.id.toString());
        _abrirModalAddTarefa(context);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsGeometry.all(10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  style: BorderStyle.solid,
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 0,
                  spreadRadius: 1.5,
                  offset: Offset(0, 1),
                ),
              ],
              color: tr.concluido
                  ? const Color.fromARGB(255, 226, 225, 225)
                  : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SizedBox(width:10),
                Checkbox(
                  value: tr.concluido,
                  onChanged: (value) async {
                    final provider = Provider.of<Tarefaprovider>(
                      context,
                      listen: false,
                    );
                    final bool retorno = await provider.onCheck(tr.id);

                    if (retorno) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tarefa marcada com sucesso!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tr.concluido
                          ? Text(
                              tr.descricao,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            )
                          : Text(
                              tr.descricao,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.calendar_month),
                          Text(DateFormat('dd-MM-yyyy').format(tr.data!)),
                          SizedBox(width: 15),
                          Icon(Icons.access_time_rounded),
                          Text(tr.hora),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: tr.porcentagemConcluida / 100,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text("${tr.porcentagemConcluida.toInt()}%"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    final provider = Provider.of<Tarefaprovider>(
                      context,
                      listen: false,
                    );
                    final bool retorno = await provider.onDelete(tr.id);

                    if (retorno) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tarefa excluida com sucesso!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
