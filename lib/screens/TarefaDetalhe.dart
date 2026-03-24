import 'package:flutter/material.dart';
import 'package:projeto_despesas/components/SubtarefaComponent.dart';
import 'package:projeto_despesas/models/Subtarefa.dart';
import '../models/Tarefa.dart';
import 'package:provider/provider.dart';
import '../providers/SubtarefaProvider.dart';
import '../providers/TarefaProvider.dart';
import 'package:intl/intl.dart';

class TarefaDetalhe extends StatefulWidget {
  TarefaDetalhe(this.tarefa);
  Tarefa tarefa;

  @override
  State<TarefaDetalhe> createState() => _TarefaDetalhe();
}

class _TarefaDetalhe extends State<TarefaDetalhe> {
  final _descricaoController = TextEditingController();
  final _dateController = TextEditingController();
  final _horaController = TextEditingController();
  final _descricaoSubtarefaController = TextEditingController();
  bool _visivel = false;
  double _porcentagem = 0;

  _addSubTarefa(BuildContext context) async {
    final bool retorno = await context.read<Subtarefaprovider>().addSubtarefa(
      context,
      new Subtarefa(
        id: 0,
        descricao: _descricaoSubtarefaController.text,
        concluido: false,
        idTarefa: widget.tarefa.id,
      ),
    );

    if (retorno) {
      if (_porcentagem.toInt() == 100) {
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
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Subtarefa adicionada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.greenAccent,
          ),
        );
      }
      _descricaoSubtarefaController.text = '';
      setState(() {
        _visivel = false;
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao adicionar subtarefa!',
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }


  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read<Subtarefaprovider>().carregarSubtarefas(
        idtarefa: widget.tarefa.id,
      );
      _descricaoController.text = widget.tarefa.descricao;
      _dateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.tarefa.data);
      _horaController.text = widget.tarefa.hora;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Subtarefaprovider>();
    final subtarefas = provider.subtarefas;

    // if (provider.subtarefas.isNotEmpty) {
    //   _porcentagem =
    //       (provider.totalSubtarefasConcluidas * 100) /
    //       provider.subtarefas.length;
    // } else {
    //   _porcentagem = 0;
    // }


    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhe tarefa'),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              child: Column(
                children: [
                  TextFormField(controller: _descricaoController),
                  TextFormField(controller: _dateController),
                  TextFormField(controller: _horaController),
                  SizedBox(height: 12),
                ],
              ),
            ),
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                :
                  // mostrar subtarefas apenas quando existir
                  subtarefas.isNotEmpty
                ? Expanded(
                    child: Column(
                      children: [
                        Text('Subtarefas'),

                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: provider.porcentagem/ 100,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text("${provider.porcentagem.toInt()}%"),
                          ],
                        ),

                        SizedBox(height: 10),

                        Expanded(
                          child: ListView.builder(
                            itemCount: subtarefas.length,
                            itemBuilder: (ctx, index) {
                              return SubtarefaComponent(subtarefas[index]);
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  )
                : Text('Nenhuma subtarefa cadastrada'),
            Visibility(
              visible: _visivel,
              child: Form(
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _descricaoSubtarefaController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        _addSubTarefa(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _visivel = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _visivel = true;
                });
              },
              label: Text('Adicionar subtarefa'),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                TextButton.icon(
                  onPressed: null,
                  label: Text('Editar', style: TextStyle(color: Colors.white)),
                  icon: Icon(Icons.edit, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: null,
                  label: Text('Excluir', style: TextStyle(color: Colors.white)),
                  icon: Icon(Icons.delete, color: Colors.white),
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
