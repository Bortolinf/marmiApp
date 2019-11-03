import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/blocs/clientes_bloc.dart';
import 'package:marmi_app/pages/prog_cli_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/utils/nav.dart';
import 'package:marmi_app/widgets/custom_drawer.dart';



import 'edtcliente_page.dart';

class ClienteScreen extends StatelessWidget {
  final String uid = appData.uid;
  final ClienteData cliente;
  final ClientesBloc _clientesBloc = BlocProvider.getBloc<ClientesBloc>();

  ClienteScreen(this.cliente);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //  appBar: _appBar(context),
      drawer: CustomDrawer(context),
      body: _body(context),
   //   floatingActionButton: _fabButton(context),
      persistentFooterButtons: _footerButtons(context), 
    );              
  }

  _footerButtons(context){
    return  
    <Widget>[
      IconButton(icon: Icon(Icons.home),
      onPressed: (){ 
          Navigator.pop(context);
          Navigator.pop(context); 
       },
      ),

      IconButton(icon: Icon(Icons.delete),
      onPressed: (){ _excluirCliente(context); },
      ),
      IconButton(icon: Icon(Icons.edit),
      onPressed: (){
                    appData.wtlopc = "A";
            push(context, EditClientePage());
      },
      ),
      IconButton(icon: Icon(Icons.phone),
      onPressed: (){
       launch("tel:${cliente.telefone}");
      },
      ),

      IconButton(icon: Icon(Icons.date_range),
      onPressed: (){ 
        appData.wtlopc = "A";
        push(context,ProgrCliPage()); },
      ),


    ];

  }






  _excluirCliente(context) {
    showDialog(
        context: context,
        barrierDismissible:
            false, // impede desmontar o dialog clicando fora dele
        builder: (context) {
          return AlertDialog(
            title: Text("Deseja excluir o cliente?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Excluir"),
                onPressed: () async{
              await _clientesBloc.excluirCliente();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
               //   pushReplacement(context, ClientesPage());
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _body(context) {
    return ListView(children: <Widget>[
      Column(
      mainAxisSize: MainAxisSize.min,     
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(8.0),
          color: Theme.of(context).accentColor,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(cliente.nome,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.place,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(cliente.endereco,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text(cliente.telefone,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                              SizedBox(width: 15,),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.textsms,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Expanded(
                                              child: Container(
                          child: Text(cliente.obs,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            
                            maxLines: 3,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
 
  
           Column(
            children: <Widget>[
             
            

              
            ]
          ),
          



      ],
    ),
 

    ],
    
    
    );

  }



} // fim de tudo
