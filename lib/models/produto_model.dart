import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:marmi_app/domain/singleton.dart';

import 'package:flutter/material.dart';

salvarProduto(
    {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
  // manda salvar os outros dados do user (endereço, etc)
  Map<String, dynamic> produtoData = {
    "descricao": appData.wtlPrdDsc,
    "valor": appData.wtlPrdVlr
  };

  // FAZER TRATAMENTO DE ERROS AQUI - ver como estruturar o Catcherror
  if (appData.wtlopc == "I") {
    await _saveProdutoData(produtoData);
  } else {
    await _updateProdutoData(produtoData);
  }

  // sucesso sempre - nada de errado vai acontecer
  onSuccess();

}

Future<Null> _saveProdutoData(Map<String, dynamic> produtodata) async {
  //_saveProdutoData(this.produtodata);
  final String uid = appData.uid;
  await Firestore.instance
      .collection("makers")
      .document(uid)
      .collection("produtos")
      .add(produtodata);
  //Firestore.instance.collection("x").add()
}

Future<Null> _updateProdutoData(Map<String, dynamic> produtodata) async {
  final String uid = appData.uid;
  await Firestore.instance
      .collection("makers")
      .document(uid)
      .collection("produtos")
      .document(appData.wtlPrdId)
      .updateData(produtodata);
  //Firestore.instance.collection("x").add()
}
