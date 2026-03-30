import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:projeto_despesas/providers/UsuarioProvider.dart';
import 'package:provider/provider.dart';

class MeusDados extends StatefulWidget {
  @override
  State<MeusDados> createState() => _MeusDados();
}

class _MeusDados extends State<MeusDados> {
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  String _email = '';
  int _tarefasPendentes = 0;
  int _tarefasConcluidas = 0;
  bool senhaVisivel = false;
  bool confirmarSenhaVisivel = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      final provider = context.read<Usuarioprovider>();
      provider.carregarDados();
      _email = provider.email;
      _tarefasConcluidas = provider.totalTarefasConcluidas;
      _tarefasPendentes = provider.totalTarefasPendentes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.account_circle, size: 130, color: Colors.grey),
                Text(_email, style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'Tarefas Concluidas: ${_tarefasConcluidas}',
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Text(
                        'Tarefas pendentes: ${_tarefasPendentes}',
                        style: TextStyle(color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.all(5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _senhaController,
                  obscureText: !senhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    prefixIcon: Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          senhaVisivel = !senhaVisivel;
                        });
                      },
                      icon: Icon(
                        senhaVisivel ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
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
                SizedBox(height: 12),
                TextField(
                  controller: _confirmarSenhaController,
                  obscureText: !confirmarSenhaVisivel,
                  decoration: InputDecoration(
                    labelText: 'Confirmar senha',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    prefixIcon: Icon(Icons.key),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          confirmarSenhaVisivel = !confirmarSenhaVisivel;
                        });
                      },
                      icon: Icon(
                        confirmarSenhaVisivel
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),

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
                SizedBox(height: 10),

                TextButton.icon(
                  onPressed: () async {
                    if (_confirmarSenhaController.text != '' &&
                        _senhaController.text != '') {
                      if (_confirmarSenhaController.text !=
                          _senhaController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'As senhas devem ser iguais!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      } else {
                        final provider = context.read<Usuarioprovider>();
                        bool retorno = await provider.alterarSenha(
                          _senhaController.text,
                        );
                        if (retorno) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Senha alterada com sucesso!',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.greenAccent,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Erro ao alterar senha!',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 3),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    }
                  },
                  label: Text(
                    'Alterar senha',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(Icons.edit, color: Colors.white),
                  style: ButtonStyle(
                    minimumSize: WidgetStatePropertyAll(
                      Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.primary,
                    ),
                    padding: WidgetStatePropertyAll(EdgeInsetsGeometry.all(18)),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
