import 'package:flutter/material.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/pages/backdrop_cli.dart';
import 'package:marmi_app/pages/prog_cli_page.dart';
import 'package:marmi_app/utils/nav.dart';

class ClienteTile extends StatelessWidget {
  final String uid = appData.uid;
  final ClienteData cliente;

  ClienteTile(this.cliente);

  @override
  Widget build(BuildContext context) {
      return InkWell(
      onTap: (){
        cliente.toWtl();
        Navigator.of(context).push(
          // manda abrir a tela de cliente passando os parametros
         // MaterialPageRoute(builder: (context)=>ClienteScreen(cliente))
          // ATIVAR ESTA LINHA PARA EXIBIR COMO BACKDROP
          MaterialPageRoute(builder: (context)=>BackDropCliente(cliente))
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
        child: Row(          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(cliente.nome,                      
                      style: TextStyle(color: Colors.grey[700], fontSize: 20.0, fontWeight: FontWeight.w500),),
                      Text(cliente.endereco,
                      style: TextStyle(color: Colors.grey[700], fontSize: 16.0, fontWeight: FontWeight.w500),),
                      Text(cliente.telefone,
                      style: TextStyle(color: Colors.grey[700], fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
            ),
            Flexible(              
              flex: 1,              
              child: 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(backgroundColor: Theme.of(context).accentColor,
                child: IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: (){
                     cliente.toWtl();
                    push(context,ProgrCliPage()); 
                  },
                ),
                ),
              ),
            ),

          
          ],

        )
        
      ),
    );

   
  }
}
