//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/pages/clientes_page.dart';
import 'package:marmi_app/pages/produtos_page.dart';
import 'package:marmi_app/pages/relatorios_page.dart';
import 'package:marmi_app/utils/nav.dart';
//import 'package:marmi_app/firebase/firebase_service.dart';
import 'package:marmi_app/widgets/custom_drawer.dart';
import 'package:marmi_app/widgets/menu_button.dart';

import 'financas_page.dart';
//import 'login_page.dart';

const Color _kFlutterBlue = Color(0xFF003D75);

class ItemMenu {
  String texto;
  Icon icone;
  Function functionName;

  ItemMenu(this.texto, this.icone, this.functionName);
}



// ----------------------------------------------------


class HomePage extends StatelessWidget {

  final String uid = appData.uid;


  @override
  Widget build(BuildContext context) {

   
//   if(UserModel.of(context).isLoggedIn()){
//    String uid2 = UserModel.of(context).firebaseUser.uid;
//   }
//   else {
//     print("retornou como false");
//   }
   

    return Scaffold(
      appBar: AppBar(
        title: Text("MarmiApp"),
      ),
      drawer: CustomDrawer(context),
      body: _body2(context),
    );
  }



  _body2(context) {
    List<ItemMenu> menuItens = [
      ItemMenu("Meus Clientes", Icon(Icons.people, size: 50.0, color: _kFlutterBlue,), onClickClientes),
      ItemMenu("Produtos", Icon(Icons.shopping_basket, size: 50.0, color: _kFlutterBlue,), onClickProdutos),
      ItemMenu("Programação", Icon(Icons.date_range, size: 50.0, color: _kFlutterBlue,), onClickClientes),
      ItemMenu("Finanças", Icon(Icons.monetization_on, size: 50.0, color: _kFlutterBlue,) ,onClickFinancas),
      ItemMenu("Relatórios", Icon(Icons.receipt, size: 50.0, color: _kFlutterBlue,) ,onClickRelatorios),
    ];

    return 
    Container(
        padding: EdgeInsets.only(top: 20, left: 16, right: 16),
        color: Colors.teal[50],
        child: GridView.builder(
    padding: EdgeInsets.all(2.0),
    
    gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemCount: menuItens.length,
    itemBuilder: (context, index) {
      return _itemView(context, menuItens, index);
    },
        ),
      );
  }

_itemView(context, List<ItemMenu> menuItens, int index) {
  ItemMenu menu = menuItens[index];
  return SizedBox(
          child: MenuButton(menu.texto, menu.icone, onPressed: () => menu.functionName(context),),
        //      Icon(Icons.contacts, size: 50.0, color: _kFlutterBlue),
        //      onPressed: () => onClickClientes(context)),
        );
}


  void onClickClientes(BuildContext context) async {
    String s = await push(context, ClientesPage());
    print(">> $s");
  }

  void onClickProdutos(BuildContext context) async {
    String s = await push(context, ProdutosPage());
    print(">> $s");

  }

  void onClickFinancas(BuildContext context) async {
    String s = await push(context, FinancasPage());
    print(">> $s");

  }

  void onClickRelatorios(BuildContext context) async {
    String s = await push(context, RelatoriosPage());
    print(">> $s");

  }


} // fim de tudo
