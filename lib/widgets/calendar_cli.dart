import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/blocs/clientes_bloc.dart';
import 'dart:collection';
import 'package:marmi_app/domain/singleton.dart';
import 'package:calendarro/date_utils.dart';
import 'package:kalendar/kalendar.dart';

class CalendarCli extends StatefulWidget {
  @override
  _CalendarCliState createState() => _CalendarCliState();
}

class _CalendarCliState extends State<CalendarCli> {
  final ClientesBloc _clientesBloc = BlocProvider.getBloc<ClientesBloc>();

  final _selectedDates = HashSet<String>();
  @override
  void initState() {
    super.initState();

    //appData.wtlDiasSel["82019"] = [1, 7, 26, 29];
  }

  @override
  Widget build(BuildContext context) {
    String ano = "";
    String mes = "";
    return Scaffold(
      //  appBar: AppBar(
      //    title: Text("Programação do cliente"), ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Kalendar(
                selectedDates: _selectedDates,
                showBorder: true,
                borderRadius: 15.0,
                dayTileMargin: 1,
                dayTileBuilder: (DayProps props) {
                  return CustomDayTile(props);
                },
                onTap: (DateTime dateTime, bool isSelected) {
                  ano = dateTime.year.toString();
                  mes = dateTime.month.toString();
                  appData.wtlMesAno = (mes + ano);
                  setState(() {
                    // if (!DateUtils.isWeekend(dateTime)) {
                    //   if (isSelected) {
                    print(appData.wtlDiasSel);
                    if (appData.wtlDiasSel[appData.wtlMesAno] != null &&
                        appData.wtlDiasSel[appData.wtlMesAno]
                            .contains(dateTime.day)) {
                      _selectedDates.remove(formatDate(dateTime));
                      appData.wtlDiasSel[appData.wtlMesAno]
                          .remove(dateTime.day);
                      print(appData.wtlDiasSel);
                    } else {
                      _selectedDates.add(formatDate(dateTime));
                      if (appData.wtlDiasSel[appData.wtlMesAno] == null) {
                        appData.wtlDiasSel[appData.wtlMesAno] = [dateTime.day];
                      } else {
                        appData.wtlDiasSel[appData.wtlMesAno].add(dateTime.day);
                      }
                      print(appData.wtlDiasSel);
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: StreamBuilder<bool>(
                          stream: _clientesBloc.outLoading,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(180.0)),
                              color: Theme.of(context).accentColor,
                              child: !snapshot.hasData
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    )
                                  : Text(
                                      "Salvar Programação",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                              onPressed: snapshot.hasData
                                  ? () async {
                                      appData.wtlopc = "A";
                                      await _clientesBloc.saveCliente();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  : null,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDayTile extends StatelessWidget {
  final DayProps props;
  CustomDayTile(this.props);
  final corFindi = Colors.grey[300];
  final corAgendado = Colors.pink[100];
  final corAdicionado = Colors.green[200];
  var corDia;

  @override
  Widget build(BuildContext context) {
    String ano = props.dateTime.year.toString();
    String mes = props.dateTime.month.toString();
    appData.wtlMesAno = (mes + ano);
    corDia = Colors.white;
    bool diaRecebido = false;
    if (props.isDayOfCurrentMonth &&
        appData.wtlDiasSel[appData.wtlMesAno] != null &&
        appData.wtlDiasSel[appData.wtlMesAno].contains(props.dateTime.day)) {
      corDia = corAgendado;
    }
    if (props.isDayOfCurrentMonth &&
        appData.wtlDiasRec[appData.wtlMesAno] != null &&
        appData.wtlDiasRec[appData.wtlMesAno].contains(props.dateTime.day)) {
      diaRecebido = true;
    }
    // finais de semana
    if (DateUtils.isWeekend(props.dateTime)) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Text(
            '${props.dateTime.day}',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(props.dayTileMargin ?? 3),
      decoration: BoxDecoration(
          // border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(30),
          //color: props.isSelected ? Colors.green : Colors.transparent,
          color: corDia),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  diaRecebido
                      ? Positioned(
                          bottom: 4,
                          left: 8,
                          child: Container(
                            height: 15,
                            width: 15,
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow.withOpacity(0.9),
                              child: Text(
                                "\$",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 10),
                              ),
                            ),
                          ))
                      : Container(),
                  Center(
                                      child: Text(
                      '${props.dateTime.day}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: props.isDayOfCurrentMonth
                            ? Colors.black87
                            : props.isSelected ? Colors.white54 : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//-----------------------------------------------------
