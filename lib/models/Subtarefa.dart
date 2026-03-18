import 'package:projeto_despesas/components/SubtarefaComponent.dart';

class Subtarefa{
  int idTarefa;
  int id = 0;
  String descricao;
  bool concluido = false;

  Subtarefa({required this.descricao,required this.concluido,required this.idTarefa});
}