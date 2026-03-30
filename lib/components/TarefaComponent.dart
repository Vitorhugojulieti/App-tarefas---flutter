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
  String _tag = '';
  var _cor = Colors.greenAccent;
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
    if (tr.porcentagemConcluida == 100 && tr.concluido) {
      _tag = 'Concluida';
    } else if (tr.porcentagemConcluida > 0) {
      _tag = 'Em andamento';
      _cor = Colors.orangeAccent;
    } else {
      _tag = 'Não iniciada';
      _cor = Colors.redAccent;
    }
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
                  color: _cor,
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
                    if (tr.concluido) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tarefa ja foi concluida!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
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
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tr.concluido
                              ? Text(
                                  tr.descricao,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                )
                              : Text(
                                  tr.descricao,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                          Container(
                            child: Text(
                              _tag,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: _cor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            padding: EdgeInsets.all(4),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(DateFormat('dd/MM/yyyy').format(tr.data!)),
                          SizedBox(width: 15),
                          Icon(
                            Icons.access_time_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          Text(DateFormat('HH:mm').format(tr.data)),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: tr.porcentagemConcluida / 100,
                              color: _cor,
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
