import 'package:flutter/material.dart';
import 'package:projeto_despesas/components/SubtarefaComponent.dart';
import 'package:projeto_despesas/models/Subtarefa.dart';
import '../models/Tarefa.dart';
import 'package:provider/provider.dart';
import '../providers/SubtarefaProvider.dart';
import 'package:intl/intl.dart';

class TarefaDetalhe extends StatefulWidget {
  TarefaDetalhe(this.tarefa);
  Tarefa tarefa;

  @override
  State<TarefaDetalhe> createState() => _TarefaDetalhe();
}

class _TarefaDetalhe extends State<TarefaDetalhe> {
  final _descricaoController = TextEditingController();
  final _dataController = TextEditingController();
  final _horaController = TextEditingController();
  final _descricaoSubtarefaController = TextEditingController();
  bool _visivel = false;
  double _porcentagem = 0;
  String _tag = '';
  var _cor = Colors.greenAccent;
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

    if (hora != null && _dataTarefa != null) {
      setState(() {
        _dataTarefa = DateTime(
          _dataTarefa!.year,
          _dataTarefa!.month,
          _dataTarefa!.day,
          hora.hour,
          hora.minute,
        );
        _horaController.text = '${hora.hour}:${hora.minute}';
      });
    }
  }

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
        debugPrint('aqui');
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
      } else {
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
      _dataController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.tarefa.data);
      _horaController.text = widget.tarefa.hora;

      if (widget.tarefa.porcentagemConcluida == 100 &&
          widget.tarefa.concluido) {
        _tag = 'Concluida';
      } else if (widget.tarefa.porcentagemConcluida > 0) {
        _tag = 'Em andamento';
        _cor = Colors.orangeAccent;
      } else {
        _tag = 'Não iniciada';
        _cor = Colors.redAccent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Subtarefaprovider>();
    final subtarefas = provider.subtarefas;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Detalhe tarefa'),
            Container(
              child: Text(
                _tag,
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: _cor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: EdgeInsets.all(4),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(12),
        child: Column(
          children: [
            //detalhes da tarefa
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    child: Column(
                      children: [
                        TextField(
                          controller: _descricaoController,
                          decoration: InputDecoration(
                            labelText: 'Descrição',
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            prefixIcon: Icon(Icons.text_fields),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
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
                        SizedBox(height: 12),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Data',
                            prefixIcon: Icon(Icons.date_range),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
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
                        SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Hora',
                            prefixIcon: Icon(Icons.timer),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 2,
                              ),
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
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //subtarefas
            provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        subtarefas.isNotEmpty
                            ? Text('Subtarefas')
                            : SizedBox(height: 10),
                        subtarefas.isNotEmpty
                            ? Row(
                                children: [
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: provider.porcentagem / 100,
                                      color: _cor,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text("${provider.porcentagem.toInt()}%"),
                                ],
                              )
                            : SizedBox(height: 10),
                        //lista subtarefas
                        subtarefas.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: subtarefas.length,
                                  itemBuilder: (ctx, index) {
                                    return SubtarefaComponent(
                                      subtarefas[index],
                                    );
                                  },
                                ),
                              )
                            : Text('Nenhuma subtarefa cadastrada!'),
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
                        widget.tarefa.concluido
                            ? SizedBox(height: 10)
                            : TextButton.icon(
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
                      ],
                    ),
                  ),
            //footer
            Expanded(
              flex: 1,
              child: !widget.tarefa.concluido
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 12,
                      children: [
                        TextButton.icon(
                          onPressed: null,
                          label: Text(
                            'Editar',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.edit, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: null,
                          label: Text(
                            'Excluir',
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(Icons.delete, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Colors.red),
                          ),
                        ),
                      ],
                    )
                  : Text('Tarefa Concluida'),
            ),
          ],
        ),
      ),
    );
  }
}
