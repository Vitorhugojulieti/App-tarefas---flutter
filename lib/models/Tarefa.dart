class Tarefa {
  int id = 0;
  String descricao = '';
  DateTime data = DateTime.now();
  String hora = '';
  bool concluido = false;
  int? idUsuario = 0;

  Tarefa({required this.id,required this.descricao,required this.data,required this.hora,this.concluido = false, this.idUsuario});

}