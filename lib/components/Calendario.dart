import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';

class Calendario extends StatefulWidget {
  Calendario({super.key});

  @override
  State<Calendario> createState() => _Calendario();
}

class _Calendario extends State<Calendario> {
  DateTime _diaFocado = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<Tarefaprovider>();
    return TableCalendar(
      locale: 'pt_BR',
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _diaFocado,
      enabledDayPredicate: (day) => true,
      calendarFormat: _calendarFormat,
      availableCalendarFormats: {
        CalendarFormat.month: 'Mês',
        CalendarFormat.week: 'Semana',
        CalendarFormat.twoWeeks: 'Duas semanas'
      },
      selectedDayPredicate: (dia) {
        return isSameDay(provider.diaSelecionado, dia);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _diaFocado = focusedDay;
          final data = DateTime(
            selectedDay.year,
            selectedDay.month,
            selectedDay.day,
          );
          provider.diaSelecionado = selectedDay;
          provider.filtraPorDia(data);
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _diaFocado = focusedDay;
        });
      },
      eventLoader: (day) {
        final data = DateTime(day.year, day.month, day.day);
        return provider.tarefasAgrupadas[data] ?? [];
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
    );
  }
}
