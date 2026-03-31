import 'package:flutter/material.dart';
import 'package:projeto_despesas/classes/ServicoNotificacao.dart';
import 'package:projeto_despesas/providers/SubtarefaProvider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';
import 'package:projeto_despesas/providers/UsuarioProvider.dart';
import 'package:provider/provider.dart';
import './screens/login_screen.dart';
import './screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Tarefaprovider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Usuarioprovider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Subtarefaprovider(),
        ),
        Provider<ServicoNotificacao>(
          create: (_)=> ServicoNotificacao(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
// StatelessWidget n possui estado
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Color.fromRGBO(34, 50, 73, 1),
          secondary: Color.fromRGBO(248, 248, 255, 1)
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=> const LoginScreen(),
        '/home':(context)=> const HomeScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

