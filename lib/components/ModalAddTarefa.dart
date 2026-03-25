import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_despesas/components/SubtarefaComponent.dart';
import 'package:projeto_despesas/models/Tarefa.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import 'package:provider/provider.dart';
import '../models/Subtarefa.dart';

class ModalAddTarefa extends StatefulWidget {
  ModalAddTarefa(this.idtarefa);
  int? idtarefa;

  @override
  State<ModalAddTarefa> createState() => _ModalAddTarefa();
}

class _ModalAddTarefa extends State<ModalAddTarefa> {
  final _descricaoController = new TextEditingController();
  final _dataController = new TextEditingController();
  final _horaController = new TextEditingController();
  DateTime? _dataTarefa = null;
  bool _inputAberto = false;

  Future<void> _selecionarData() async {
    DateTime? _selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_selecionada != null) {
      //_dataTarefa = DateFormat('dd/MM/yyyy').format(_selecionada).toString().split(' ')[0];
      setState(() {
        _dataTarefa = _selecionada;
        _dataController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(_selecionada).toString().split(' ')[0];
      });
    }
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora != null) {
      setState(() {
        _horaController.text = '${hora.hour}:${hora.minute}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<Tarefaprovider>();
      if (widget.idtarefa == null) {
        _dataTarefa = provider.diaSelecionado;
        _dataController.text = DateFormat(
          'dd/MM/yyyy',
        ).format(provider.diaSelecionado);
      } else {
        Tarefa tr = provider.tarefas.firstWhere((t) => t.id == widget.idtarefa);
        _dataController.text = DateFormat('dd/MM/yyyy').format(tr.data);
        _dataTarefa = tr.data;
        _descricaoController.text = tr.descricao;
        _horaController.text = tr.hora;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nova tarefa',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 21,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.secondary,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  TextField(
                    controller: _descricaoController,
                    decoration: InputDecoration(
                      labelText: 'Descrição',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: Icon(Icons.text_fields),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Data',
                      prefixIcon: Icon(Icons.date_range),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selecionarData();
                    },
                    controller: _dataController,
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Hora',
                      prefixIcon: Icon(Icons.timer),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _horaController,
                    readOnly: true,
                    onTap: () {
                      _selecionarHora();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: LinearProgressIndicator(value: 0.2)),
                  SizedBox(width: 10),
                  Text("${(0.2 * 100).toInt()}%"),
                ],
              ),
              widget.idtarefa != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subtarefas', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 10),
                        //column para listagem de subtarefas, trocar para um listbuilder
                        Column(
                          children: [
                            SubtarefaComponent(
                              new Subtarefa(
                                concluido: false,
                                descricao: 'Teste',
                                idTarefa: 1,
                                id: 0
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Visibility(
                          visible: _inputAberto,
                          child: Row(
                            children: [
                              Expanded(child: TextField()),
                              IconButton(
                                onPressed: null,
                                icon: Icon(Icons.check, color: Colors.green),
                                color: Theme.of(context).colorScheme.primary,
                                iconSize: 32,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _inputAberto = false;
                                  });
                                },
                                icon: Icon(Icons.cancel, color: Colors.red),
                                color: Theme.of(context).colorScheme.primary,
                                iconSize: 32,
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              debugPrint('ta aqui');
                              _inputAberto = true;
                            });
                          },
                          label: Text(
                            'Adicionar subtarefa',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(height: 5),
              TextButton.icon(
                onPressed: () async {
                  final agora = DateTime.now();
                  final hoje = DateTime(agora.year, agora.month, agora.day);
                  debugPrint(_dataTarefa!.isBefore(hoje).toString());
                  if (_dataTarefa!.isBefore(hoje)) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Data da tarefa não pode ser menor que a atual!',
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  } else {
                    final provider = Provider.of<Tarefaprovider>(
                      context,
                      listen: false,
                    );
                    final bool resultado = await provider.addTarefa(
                      context,
                      new Tarefa(
                        id: 0, //quando buscar o id do banco n precis mais add
                        descricao: _descricaoController.text,
                        data: _dataTarefa!,
                        hora: _horaController.text,
                        porcentagemConcluida: 0
                      ),
                    );
                    if (resultado) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tarefa cadastrada com sucesso!',
                            style: TextStyle(color: Colors.white),
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.greenAccent,
                        ),
                      );
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary,
                  ),
                  padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(21)),
                ),
                label: Text(
                  widget.idtarefa == null ? 'Cadastrar' : 'Editar',
                  style: TextStyle(color: Colors.white),
                ),
                icon: widget.idtarefa == null
                    ? Icon(Icons.save, color: Colors.white)
                    : Icon(Icons.edit, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
