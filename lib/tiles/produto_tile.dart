import 'package:flutter/material.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/pages/produto_page.dart';

class ProdutoTile extends StatelessWidget {
  final String uid = appData.uid;
  final ProdutoData produto;

  ProdutoTile(this.produto);

  @override
  Widget build(BuildContext context) {
      return InkWell(
      onTap: (){
        produto.toWtl();
        Navigator.of(context).push(
          // manda abrir a tela de produto passando os parametros
          MaterialPageRoute(builder: (context)=>ProdutoScreen(produto))
        );
      },
      child: Card(        
        margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
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
                        Text(produto.descricao,                      
                        style: TextStyle(color: Colors.grey[700], fontSize: 20.0, fontWeight: FontWeight.w500),),
                      ],
                    ),
                  ),
              ),
              Flexible(              
                flex: 2,              
                child: 
                Text("R\$ ${produto.valor.toStringAsFixed(2)} ",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
              ),

            ],

          ),
        )
        
      ),
    );

   
  }
}
