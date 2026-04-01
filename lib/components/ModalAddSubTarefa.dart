import 'package:flutter/material.dart';
import 'package:projeto_despesas/models/Subtarefa.dart';
import 'package:projeto_despesas/providers/SubtarefaProvider.dart';
import 'package:provider/provider.dart';

class ModalAddSubTarefa extends StatefulWidget {
  ModalAddSubTarefa(this.idTarefa);
  int idTarefa;
  @override
  State<ModalAddSubTarefa> createState() => _ModalAddSubTarefa();
}

class _ModalAddSubTarefa extends State<ModalAddSubTarefa> {
  final _descricaoController = new TextEditingController();

  _cadastrarSubTarefa() async {
    if (_descricaoController.text == '') {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Descrição da subtarefa não pode estar vazia!',
            style: TextStyle(color: Colors.white),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
        ),
      );
    } else {
      final provider = Provider.of<Subtarefaprovider>(context, listen: false);
      final bool resultado = await provider.addSubtarefa(
        context,
        new Subtarefa(
          concluido: false,
          descricao: _descricaoController.text,
          idTarefa: widget.idTarefa,
          id: 0,
        ),
      );
      if (resultado) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Subtarefa cadastrada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
            backgroundColor: Colors.greenAccent,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erro ao cadastrar subtarefa!',
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

  _cancelar() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Nova SubTarefa',
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
            height: MediaQuery.of(context).size.height * 0.2,
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
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          await _cadastrarSubTarefa();
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
