import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/singleton.dart';

class ClienteData {
  String id;
  String nome;
  String endereco;
  String telefone;
  String obs;
  int pessoas;
  Map<String,List<dynamic>> programacao;
  Map<String,List<dynamic>> recebido;


  // contrutor q cria o objeto a partir do snapshot
  ClienteData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    nome = snapshot.data["nome"];
    endereco = snapshot.data["endereco"];
    telefone = snapshot.data["telefone"];
    obs = snapshot.data["obs"];
    // isso serve para resolver problemas qdo é informado um preco inteiro no firebase
    pessoas = snapshot.data["pessoas"] + 0;

   // print(snapshot.data["programacao"]);

    
    // olha o que tive que fazer para trazer aquela lista dos dias para dentro do meu sistema
    // - varro o mapa e executo a void abaixo - p/cada mapa eu inicializo a lista (caso não exista)
    //  e vou varrendo cada elemento com o dia e adicionando a nova lista
    
    programacao = {};
    if (snapshot.data["programacao"] != null) {
        void iterateMapEntry(key, value) {
            snapshot.data["programacao"][key] = value;
         //   print('$key:$value');//string interpolation in action
           for(int d in value) {
              if (programacao[key] == null){
                programacao[key] = [];
              }
              programacao[key].add((d).toInt());
           }
          }
          // pra cada mapa faz a rotina acima
          snapshot.data["programacao"].forEach(iterateMapEntry);
      }


    recebido = {};
    if (snapshot.data["recebido"] != null) {
        void iterateMapEntry(key, value) {
            snapshot.data["recebido"][key] = value;
         //   print('$key:$value');//string interpolation in action
           for(int d in value) {
              if (recebido[key] == null){
                recebido[key] = [];
              }
              recebido[key].add((d).toInt());
           }
          }
          snapshot.data["recebido"].forEach(iterateMapEntry);
      }

  } //finaleira







  // contrutor q cria o objeto a partir de um map
  ClienteData.fromMap(Map<String, dynamic> cli){
    id = cli["id"];
    nome = cli["nome"];
    endereco = cli["endereco"];
    telefone = cli["telefone"];
    obs = cli["obs"];
    // isso serve para resolver problemas qdo é informado um preco inteiro no firebase
    pessoas = cli["pessoas"] + 0;

    programacao = {};
    if (cli["programacao"] != null) {
        void iterateMapEntry(key, value) {
            cli["programacao"][key] = value;
           for(int d in value) {
              if (programacao[key] == null){
                programacao[key] = [];
              }
              programacao[key].add((d).toInt());
           }
          }
          // pra cada mapa faz a rotina acima
          cli["programacao"].forEach(iterateMapEntry);
      }


    recebido = {};
    if (cli["recebido"] != null) {
        void iterateMapEntry(key, value) {
            cli["recebido"][key] = value;
           for(int d in value) {
              if (recebido[key] == null){
                recebido[key] = [];
              }
              recebido[key].add((d).toInt());
           }
          }
          cli["recebido"].forEach(iterateMapEntry);
      }

  } //finaleira








  // metodo toMap p/retornar um mapa c/dados do cliente
  Map<String, dynamic> toMap(){
    return {
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone,
      "obs": obs,
      "pessoas": pessoas,
      "programacao" : programacao
    };
  }


  // metodo toWtl p/mover para as minhas WTLs
   toWtl(){
     appData.wtlCliId = id;
     appData.wtlCliNom = nome;
     appData.wtlCliEnd = endereco;
     appData.wtlCliTel = telefone;
     appData.wtlCliObs = obs;
     appData.wtlCliPess = pessoas;
     if (programacao == null) {
        appData.wtlDiasSel = {};
     } else {
        appData.wtlDiasSel = programacao;
     }
     if (recebido == null) {
        appData.wtlDiasRec = {};
     } else {
        appData.wtlDiasRec = recebido;
     }
  }


  // metodo toResumedMap p/retornar um mapa c/dados resumidos do cliente
  Map<String, dynamic> toResumedMap(){
    return {
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone
    };
  }
  
} // fim da classe cliente



  // metodo wtltoMap jogar das WTLs para mapa c/dados do cliente
Map<String, dynamic> clientewtlToMap(){
    return {
      "nome": appData.wtlCliNom,
      "endereco": appData.wtlCliEnd,
      "telefone": appData.wtlCliTel,
      "obs": appData.wtlCliObs,
      "pessoas": appData.wtlCliPess,
      "programacao" : appData.wtlDiasSel,
      "recebido" : appData.wtlDiasRec
    };
 }



//  produto ------------------------------------------------------------------------


class ProdutoData {
  String id;
  String descricao;
  double valor;


  // contrutor q cria o objeto a partir do snapshot
  ProdutoData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    descricao = snapshot.data["descricao"];
    // isso serve para resolver problemas qdo é informado um preco inteiro no firebase
    valor = snapshot.data["valor"] + 0.0;
  }


  // metodo toMap p/retornar um mapa c/dados do cliente
  Map<String, dynamic> toMap(){
    return {
      "descricao": descricao,
      "valor": valor
    };
  }


  // metodo toWtl p/mover para as minhas WTLs
   toWtl(){
     appData.wtlPrdId = id;
     appData.wtlPrdDsc = descricao;
     appData.wtlPrdVlr = valor;
  }


  // metodo toResumedMap p/retornar um mapa c/dados resumidos do cliente
  Map<String, dynamic> toResumedMap(){
    return {
      "descricao": descricao,
      "valor": valor
    };
  }
  
} // fim da classe cliente



  // metodo wtltoMap jogar das WTLs para mapa c/dados do cliente
Map<String, dynamic> produtowtlToMap(){
    return {
      "descricao": appData.wtlPrdDsc,
      "valor": appData.wtlPrdVlr,
    };
 }






