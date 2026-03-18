import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:projeto_despesas/providers/TarefaProvider.dart';

class CarrocelDias extends StatefulWidget{
  CarrocelDias(this.datas);
  List<DateTime> datas;

  @override
  State<CarrocelDias> createState()=> _CarrocelDias();
}

class _CarrocelDias extends State<CarrocelDias>{
  final ScrollController controller = ScrollController(); 
  List<DateTime> lista = [];
  DateTime diaSelecionado = DateTime.now();



  @override
  void initState(){
    super.initState();
    List<DateTime> listaGerada = List.generate(10, (index){
      DateTime hoje = DateTime.now();
      DateTime dataBase = DateTime(
        hoje.year,
        hoje.month,
        hoje.day,
      );
      return dataBase.add(Duration(days:index));
    });

    lista = [...widget.datas];
    //debugPrint(lista.length.toString());
  }
  @override
  Widget build(BuildContext context){
    final provider = context.watch<Tarefaprovider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.12,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey,style: BorderStyle.solid,width: .5)
        )
      ),
      child:Scrollbar(
        thumbVisibility: true,
        controller: controller,
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: ListView.builder(
          controller: controller,
          scrollDirection: Axis.horizontal,
          itemCount: widget.datas.length,
          itemBuilder: (context,index){
            final dia = widget.datas[index];

            return GestureDetector(
              onTap: (){
                setState(() {
                  diaSelecionado = DateTime(
                    dia.year,
                    dia.month,
                    dia.day
                  );
                  debugPrint(lista.toString());
                  //debugPrint(diaSelecionado.toString());
                  context.read<Tarefaprovider>().filtraPorDia(diaSelecionado);
                });
              },
              child: Container(
                decoration:BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: .5
                  ),
                  color: dia == provider.diaSelecionado ?Theme.of(context).colorScheme.primary : Colors.white,
                ),
                width: 70,
                child: Column(
                  children: [
                    Text(
                      DateFormat('EEE').format(dia),
                        style: TextStyle(
                          color:dia == provider.diaSelecionado ?Colors.white : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    Text(
                      DateFormat('dd').format(dia),
                        style: TextStyle(
                          color: dia == diaSelecionado ?Colors.white : Theme.of(context).colorScheme.primary,
                        )
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      )
    );
  }
}