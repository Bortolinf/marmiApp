import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/blocs/clientes_bloc.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/pages/edtcliente_page.dart';
import 'package:marmi_app/tiles/cliente_tile.dart';
import 'package:marmi_app/utils/nav.dart';
import 'package:marmi_app/widgets/custom_drawer.dart';


class ClientesPage extends StatefulWidget {
  @override
  _ClientesPageState createState() => _ClientesPageState();
}


class _ClientesPageState extends State<ClientesPage> {

 final ClientesBloc _cliBloc = BlocProvider.getBloc<ClientesBloc>();

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
      ),
      drawer: CustomDrawer(context),
     // body: _bodySemBloc(context),
      body: _body(context),
      floatingActionButton: _fabButton(context),
    );
  }

_fabButton(context) {
  return FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () {
      appData.wtlopc = "I";
      push(context, EditClientePage());
    },
  );
}


//   com bloc
  _body(context) {
    return StreamBuilder<List>(
          initialData: [],
          stream: _cliBloc.outClientes2,
          builder:  (context, snapshot) {
             if(snapshot.hasError)
             return Center(
                child: Text("Ocorreu um erro ao carregar os dados"),
            );
            else if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if(snapshot.data.length == 0)
            return Center(
              child: Text("Nenhum cliente cadastrado"),
            );
            else
              return
                ListView.builder(
                padding: EdgeInsets.all(4.0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  ClienteData data =
                      ClienteData.fromDocument(snapshot.data[index]);
                  return ClienteTile(data);
                },
              );
          });
  }



} // fim da linha
