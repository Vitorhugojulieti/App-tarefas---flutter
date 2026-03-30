import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:projeto_despesas/models/Tarefa.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';

class ServicoNotificacao {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  //construtor
  ServicoNotificacao() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _configuraAndroidDetails();
    _setupNotifications();
  }

  //configuracoes android
  _configuraAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'tarefa_notificacoes',
      'tarefa',
      channelDescription: 'Canal de notificacao de tarefas',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      enableLights: true,
    );
  }

  _setupNotifications() async {
    await _defineTimezone();
    await _inicializaNotificacoes();
  }

  Future<void> _defineTimezone() async {
    tz.initializeTimeZones();
    // Define manualmente o timezone (Brasil)
    tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
  }

  _inicializaNotificacoes() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    ); //define icone da notificacao
    await localNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
      //onSelectNotification: // para executar uma fn quando clicar na notificacao
    );
  }

  // _onSelectNotification(String? payload) {
  //   if (payload != null && payload.isNotEmpty) {
  //     Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed(payload);
  //   }
  // }

  agendarNotificacao(BuildContext context,Tarefa tarefa) {
    try {
      localNotificationsPlugin.zonedSchedule(
        tarefa.id,
        tarefa.descricao,
        tarefa.hora,
        tz.TZDateTime.from(tarefa.data, tz.local),
        NotificationDetails(android: androidDetails),
        //payload: notification.payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // showLocalNotification(CustomNotification notification) {
  //   localNotificationsPlugin.show(
  //     notification.id,
  //     notification.title,
  //     notification.body,
  //     NotificationDetails(
  //       android: androidDetails,
  //     ),
  //     payload: notification.payload,
  //   );
  // }

  inicializadoPorNotificacao() async {
    final details = await localNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      // executar fn para quando aberto pela notificacao
    }
  }
}
