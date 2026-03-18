import 'package:flutter/widgets.dart';
import '../models/Tarefa.dart';
import 'package:intl/intl.dart';
import '../components/TarefaComponent.dart';

class ListatarefasAgrupadas extends StatelessWidget {
  ListatarefasAgrupadas(this.tarefasAgrupadas);
  Map<DateTime, List<Tarefa>> tarefasAgrupadas;
  
  @override
  Widget build(BuildContext context) {
    final datas = tarefasAgrupadas.keys.toList()..sort();
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.9,
      child: ListView.builder(
        itemCount: datas.length,
        itemBuilder: (ctx, index) {
          final data = datas[index];
          final tarefas = tarefasAgrupadas[data]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat('dd-MM-yyyy').format(data)),
              ...tarefas.map((tarefa) {
                return Tarefacomponent(tarefa);
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
