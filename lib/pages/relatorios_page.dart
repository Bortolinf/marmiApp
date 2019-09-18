import 'package:marmi_app/reports/clientes_report.dart';
import 'package:marmi_app/reports/financeiro_report.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/widgets/menu_button.dart';

const Color _kFlutterBlue = Color(0xFF003D75);

class RelatoriosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selecione um Relatório"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MenuButton(
              "Financeiro",
              Icon(
                Icons.monetization_on,
                size: 50.0,
                color: _kFlutterBlue,
              ),
              onPressed: () => financeiroReport(),
            ),
            MenuButton(
              "Programação",
              Icon(
                Icons.date_range,
                size: 50.0,
                color: _kFlutterBlue,
              ),
              onPressed: () => financeiroReport(),
            ),
            MenuButton(
              "Clientes",
              Icon(
                Icons.people,
                size: 50.0,
                color: _kFlutterBlue,
              ),
              onPressed: () => clientesReport(),
            ),
          ],
        ),
      ),
    );
  }
} // fim de tudo

// RaisedButton(
//                child: Text("Movimentação Financeira", style: TextStyle(fontSize: 18),),
//                onPressed: (){
//                  _movimentacaoFinanceira(context);
//                },
