import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/utils/nav.dart';
import 'package:marmi_app/widgets/custom_drawer.dart';

import 'produtos_page.dart';
import 'edtproduto_page.dart';

class ProdutoScreen extends StatelessWidget {
  final String uid = appData.uid;
  final ProdutoData produto;

  ProdutoScreen(this.produto);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      drawer: CustomDrawer(context),
      body: _body(context),
    );
  }


_appBar(context){
  return AppBar(
        title: Text("Detalhes do Produto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
                 _excluirProduto(context);
            }, 
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
                    appData.wtlopc = "A";
                    push(context, EditProdutoPage());
            },
          ),
          ],
      );
}

_excluirProduto(context){
     showDialog(
        context: context,
        barrierDismissible:
            false, // impede desmontar o dialog clicando fora dele
        builder: (context) {
          return AlertDialog(
            title: Text("Deseja excluir o produto?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Excluir"),
                onPressed: () async {
                  await Firestore.instance.collection("makers").document(uid).collection("produtos").document(produto.id).delete();
                  pushReplacement(context, ProdutosPage());
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




_body(context){
  return Column(
    children: <Widget>[
      Text(produto.id, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      Text(produto.descricao, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      Text(produto.valor.toString(), style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      
    ],
  );
  
}


}