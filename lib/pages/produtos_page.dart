import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/tiles/produto_tile.dart';
import 'package:marmi_app/utils/nav.dart';
import 'package:marmi_app/widgets/custom_drawer.dart';

import 'edtproduto_page.dart';

class ProdutosPage extends StatelessWidget {
  final String uid = appData.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
      ),
      drawer: CustomDrawer(context),
      body: _body(context),
      floatingActionButton: _fabButton(context),
    );
  }

_fabButton(context) {
  return FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: () {
      appData.wtlopc = "I";
      push(context, EditProdutoPage());
    },
  );
}



  _body(context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("makers")
            .document(uid)
            .collection("produtos").orderBy("valor").snapshots(),
            
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
            return
                // 2. Modo de visualizacao em lista
                ListView.builder(
              padding: EdgeInsets.all(4.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                // essa abastracao aqui foi feita para que a categoria ficasse disponivel
                // no momento de adicionar o produto ao carrinho de compras
                ProdutoData data =
                    ProdutoData.fromDocument(snapshot.data.documents[index]);
                //  data.category = this.snapshot.documentID;
                return ProdutoTile(data);
              },
            );
        });
  }




}
