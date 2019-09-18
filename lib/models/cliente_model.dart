import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:marmi_app/domain/singleton.dart';

import 'package:flutter/material.dart';

salvarCliente(
    {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
  Map<String, dynamic> clienteData = {
    "nome": appData.wtlCliNom,
    "endereco": appData.wtlCliEnd,
    "telefone": appData.wtlCliTel,
    "obs": appData.wtlCliObs,
    "pessoas": appData.wtlCliPess
  };

  // FAZER TRATAMENTO DE ERROS AQUI - ver como estruturar o Catcherror
  print("entramos no salvarCliente");
  if (appData.wtlopc == "I") {
    await _saveClienteData(clienteData);
  } else {
    await _updateClienteData(clienteData);
  }

  // sucesso sempre - nada de errado vai acontecer
  onSuccess();

}

Future<Null> _saveClienteData(Map<String, dynamic> clientedata) async {
  //_saveClienteData(this.clientedata);
  final String uid = appData.uid;
  await Firestore.instance
      .collection("makers")
      .document(uid)
      .collection("clientes")
      .add(clientedata).catchError((e) {
         print("erro ao incluir cliente $e");});
  //Firestore.instance.collection("x").add()
}

Future<Null> _updateClienteData(Map<String, dynamic> clientedata) async {
  final String uid = appData.uid;
  await Firestore.instance
      .collection("makers")
      .document(uid)
      .collection("clientes")
      .document(appData.wtlCliId)
      .updateData(clientedata).catchError((e) {
         print("erro ao atualizar cliente $e");});
}






salvarProgramacao(
    {@required VoidCallback onSuccess, @required VoidCallback onFail}) async {
  // manda salvar os outros dados do user (endereço, etc)
  Map<String, dynamic> progrData = {
    "programacao": appData.wtlDiasSel,
  };

  // FAZER TRATAMENTO DE ERROS AQUI - ver como estruturar o Catcherror
  print("entramos no salvarProgramacao");
  await _updateClienteProgramacao(progrData);
  onSuccess();

}

Future<Null> _updateClienteProgramacao(Map<String, dynamic> progrdata) async {
  final String uid = appData.uid;
  await Firestore.instance
      .collection("makers")
      .document(uid)
      .collection("clientes")
      .document(appData.wtlCliId)
      .updateData(progrdata)
      .catchError((e) {
         print("erro ao gravar programacao: $e");});
    //  .add(appData.wtlDiasSel);
    //  .add(progrdata);
}


