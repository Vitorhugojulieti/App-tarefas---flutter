import 'package:shared_preferences/shared_preferences.dart';


class Servicosessao {
  Future<void> salvarSessao(int idUsuario) async {
    final sessao = await SharedPreferences.getInstance();

    await sessao.setInt('idUsuario', idUsuario);
    await sessao.setBool('logado', true);
  }

  Future<bool> estaLogado() async {
    final sessao = await SharedPreferences.getInstance();
    return sessao.getBool('logado') ?? false;
  }


  Future<int?> getUsuarioLogado() async {
    final sessao = await SharedPreferences.getInstance();

    if (sessao.getBool('logado') ?? false) {
      return sessao.getInt('idUsuario');
    }
    return 0;
  }
}