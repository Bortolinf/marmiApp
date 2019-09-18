import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/pages/cliente_page.dart';
import 'package:marmi_app/widgets/calendar_cli.dart';

class BackDropCliente extends StatelessWidget {
    final String uid = appData.uid;
  final ClienteData cliente;

  BackDropCliente(this.cliente);

  @override
  Widget build(BuildContext context) {
    final double headerHeight = 128.0;
    final double appbarHeight = kToolbarHeight;
    final double backLayerHeight =
        MediaQuery.of(context).size.height - headerHeight - appbarHeight;
    return BackdropScaffold(
      title: Text("Dados do cliente"),
      iconPosition: BackdropIconPosition.action,
      headerHeight: 80.0,
      frontLayer: ClienteScreen(cliente),
      backLayer: Column(
        children: <Widget>[
          SizedBox(height: backLayerHeight, child:  CalendarCli())
        ],
      ),
     
      
    );
  }
}