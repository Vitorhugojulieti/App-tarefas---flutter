class Tarefa {
  int id = 0;
  String descricao = '';
  DateTime data = DateTime.now();
  String hora = '';
  bool concluido = false;
  int? idUsuario = 0;
  int porcentagemConcluida = 0;
  DateTime? dataNotificacao = null; // atributo criado para armazenar a data e hora corretamente para notificação

  Tarefa({required this.id,required this.descricao,required this.data,required this.hora,this.concluido = false, this.idUsuario,required this.porcentagemConcluida,this.dataNotificacao});
}