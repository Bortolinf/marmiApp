import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marmi_app/blocs/despesas_bloc.dart';
import 'package:marmi_app/blocs/receitas_bloc.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/widgets/custom_drawer.dart';
import 'package:marmi_app/widgets/edit_despesa_dialog.dart';
import 'package:marmi_app/widgets/edit_receita_dialog.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';



class FinancasPage extends StatefulWidget {
  @override
  _FinancasPageState createState() => _FinancasPageState();
}

class _FinancasPageState extends State<FinancasPage> {
  final DespesasBloc _despesasBloc = BlocProvider.getBloc<DespesasBloc>();
  final ReceitasBloc _receitasBloc = BlocProvider.getBloc<ReceitasBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: CustomDrawer(context),
      body: _body(context),
      persistentFooterButtons: _footerButtons(context),
    );
  }






//--------------------------------------------------------------
  _appBar(context){
    List<PopupMenuItem> listFiltro =  [
              PopupMenuItem(
                child: Text("Exibir Todos"),
                value: "T",
              ),
              PopupMenuItem(
                child: Text("Ùltimos 30 dias"),
                value: "30",
              ),
              PopupMenuItem(
                child: Text("Ùltimos 15 dias"),
                value: "15",
              ),
              PopupMenuItem(
                child: Text("Ùltima Semana"),
                value: "7",
              ),
            ];
    return AppBar(
        title: Text("Finanças"),
        actions: <Widget>[
          PopupMenuButton(icon: Icon(Icons.filter_list),
          itemBuilder: (BuildContext context) {
            return listFiltro;
          },
          onSelected: ((s){
            appData.wtlFiltroFin = s;
            print(appData.wtlFiltroFin);
            _despesasBloc.setFilterDespesas(s);
            _receitasBloc.setFilterReceitas(s);
          }
          )
          )],
      );
  }

//--------------------------------------------------------------------------------
  _body(context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Card(
              child: ExpansionTile(
                key: Key("1"),
                initiallyExpanded: true,
                title: Text(
                  "Despesas",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[300]),
                ),
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                    child: _montaListaDespesas(context),
                  )
                ],
              ),
            ),
            //---------------
            Card(
              child: ExpansionTile(
                key: Key("1"),
                initiallyExpanded: true,
                title: Text(
                  "Receitas",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                    child: _montaListaReceitas(context), 
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



 // lista das despesas
  _montaListaDespesas(context) {
    return StreamBuilder<List>(
        // initialData: [],
        stream: _despesasBloc.outDespesas,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            );
          else if (snapshot.data.length == 0)
            return Container();
          else
            return ListView.builder(              
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> desp = snapshot.data[index];
                // aqui testo se deve exibir o dado
                if (desp["visible"]) {
                return ListTile(
                  isThreeLine: false,
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                  title: Text(DateFormat('dd-MM-yyyy').format(desp["data"].toDate())), 
                  subtitle: Text(desp["descricao"]),
                  trailing: Text("R\$ ${desp["valor"].toStringAsFixed(2)}"),
                  onTap: () {
                    appData.wtlopc = "A";
                    appData.wtlDespId = desp["id"];
                    appData.wtlDespDate = desp["data"].toDate();
                    appData.wtlDespDsc = desp["descricao"];
                    appData.wtlDespVlr = desp["valor"].toDouble();
                    showDialog(
                        context: context,
                        builder: (context) => EditDespesaDialog());
                  },
                );
               }
               else {return Container();}
              },
            );
        });
  }


 //lista das receitas
 _montaListaReceitas(context){
    return StreamBuilder<List>(
        stream: _receitasBloc.outReceitas,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.blue),
              ),
            );
          else if (snapshot.data.length == 0)
            return Container();
          else
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> rec = snapshot.data[index];
                 if (rec["visible"]) {
                return ListTile(
                  isThreeLine: false,
                  dense: true,
                  contentPadding: EdgeInsets.only(left: 16, right: 16),
                  title:  Text(DateFormat('dd-MM-yyyy').format(rec["data"].toDate())),  
                  subtitle: Text(rec["descricao"] + " - " + rec["clienteNome"]),
                  trailing: Text("R\$ ${rec["valor"].toStringAsFixed(2)}"),
                  onTap: () {
                    appData.wtlopc = "A";
                    appData.wtlRecId = rec["id"];
                    appData.wtlRecDate = rec["data"].toDate();
                    appData.wtlRecDsc = rec["descricao"];
                    appData.wtlRecCli = rec["clienteId"];
                    appData.wtlRecCliNome = rec["clienteNome"];
                    appData.wtlRecVlr = rec["valor"].toDouble();
                    showDialog(
                        context: context,
                        builder: (context) => EditReceitaDialog());
                  },
                );
                 }
                 else {
                   return Container();
                 }
              },
            );
        });

 }



  _footerButtons(context) {
    return <Widget>[
      MaterialButton(
        minWidth: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              MdiIcons.cashRefund,
              size: 30,
            ),
            Text("Pagamento"),
          ],
        ),
        onPressed: () {
          appData.wtlopc = "I";
          showDialog(
              context: context, builder: (context) => EditDespesaDialog());
        },
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "Saldo atual",
            style: TextStyle(fontSize: 12),
          ),
          StreamBuilder<List>(
            stream: _receitasBloc.outReceitas,
            builder: (context, snapshot1)
            {
              return StreamBuilder<List>(
                // initialData: [],
                stream: _despesasBloc.outDespesas,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ),
                    );
                  else
                    print("snap: ${snapshot.data}");
                  return Text(
                    "R\$ ${appData.wtlSaldoAtu.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  );
                });
            }
          ),
        ],
      ),
      MaterialButton(
        minWidth: 110,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              MdiIcons.cashMultiple,
              size: 30,
            ),
            Text("Recebimento"),
          ],
        ),
        onPressed: () {
          appData.wtlopc = "I";
          showDialog(
              context: context, builder: (context) => EditReceitaDialog());
        },
      ),
    ];
  }
} // fim de tudo
