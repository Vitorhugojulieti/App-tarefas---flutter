import 'package:flutter/material.dart';
import 'package:projeto_despesas/components/ListaTarefasAgrupadas.dart';
import 'package:provider/provider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';

class Tarefasconcluidas extends StatefulWidget {
  const Tarefasconcluidas();
  @override
  State<Tarefasconcluidas> createState() => _Tarefasconcluidas();
}

class _Tarefasconcluidas extends State<Tarefasconcluidas> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<Tarefaprovider>();
      debugPrint(provider.tarefasAgrupadas.toString());
      provider.carregarTarefas(
        concluido: 'S',
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Tarefaprovider>();
    debugPrint(provider.tarefasAgrupadas.toString());
    return provider.isLoading
        ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
        : Container(
            padding: EdgeInsetsGeometry.all(10),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Expanded(
                    child: ListatarefasAgrupadas(provider.tarefasAgrupadas),
                  ),
                ],
              ),
            ),
          );
  }
}
