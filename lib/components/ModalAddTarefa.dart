import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_despesas/models/Tarefa.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import 'package:provider/provider.dart';

class ModalAddTarefa extends StatefulWidget {
  ModalAddTarefa();

  @override
  State<ModalAddTarefa> createState() => _ModalAddTarefa();
}

class _ModalAddTarefa extends State<ModalAddTarefa> {
  final _descricaoController = new TextEditingController();
  final _dataController = new TextEditingController();
  final _horaController = new TextEditingController();
  DateTime? _dataTarefa = null;
  DateTime? _dataNotificacao = null;
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
        _dataNotificacao = DateTime(
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

  _cadastrarTarefa() async {
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
      final provider = Provider.of<Tarefaprovider>(context, listen: false);
      final bool resultado = await provider.addTarefa(
        context,
        new Tarefa(
          id: 0, //quando buscar o id do banco n precis mais add
          descricao: _descricaoController.text,
          data: _dataTarefa!,
          hora: _horaController.text,
          porcentagemConcluida: 0,
          dataNotificacao : _dataNotificacao
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
  }

  _cancelar() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<Tarefaprovider>();
      _dataTarefa = provider.diaSelecionado;
      _dataController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(provider.diaSelecionado);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Nova tarefa',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
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
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
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
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await _cadastrarTarefa();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary,
                          ),
                          padding: WidgetStatePropertyAll(
                            EdgeInsetsGeometry.all(21),
                          ),
                        ),
                        label: Text(
                          'Cadastrar',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.save, color: Colors.white),
                      ),
                      SizedBox(width: 15),
                      TextButton.icon(
                        onPressed: () {
                          _cancelar();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                          padding: WidgetStatePropertyAll(
                            EdgeInsetsGeometry.all(21),
                          ),
                        ),
                        label: Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(Icons.cancel, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
