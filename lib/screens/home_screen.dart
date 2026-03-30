import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_despesas/models/Tarefa.dart';
import 'package:projeto_despesas/screens/MeusDados.dart';
import 'package:projeto_despesas/screens/Tarefas.dart';
import 'package:projeto_despesas/screens/login_screen.dart';
import '../screens/TarefasConcluidas.dart';
import '../components/ModalAddTarefa.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final List<Tarefa> tarefas = [];

  _abrirModalAddTarefa(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ModalAddTarefa();
      },
    );
  }

  int _paginaAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _paginas = [Tarefas(), Tarefasconcluidas(), MeusDados()];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: Container(
          padding: EdgeInsetsGeometry.all(10),
          alignment: Alignment.centerLeft,
          child: Text(
            'Hoje, ${DateFormat("dd 'de' MMMM", 'pt_br').format(DateTime.now())}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leadingWidth: 150,
        actions: [
          // IconButton(
          //   onPressed: () => null,
          //   icon: Icon(Icons.calendar_month_outlined, color: Colors.white),
          // ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            icon: Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: _paginas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tarefas'),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tarefas realizadas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Meus dados',
          ),
        ],
      ),
      floatingActionButton: _paginaAtual != 2 ? FloatingActionButton(
        onPressed: () => _abrirModalAddTarefa(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white),
      ) : SizedBox(height: 10)
    );
  }
}
