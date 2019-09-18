import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/utils/date_utils.dart';
import 'package:rxdart/rxdart.dart';

class ReceitasBloc extends BlocBase {

  final _receitasController = BehaviorSubject<List>();
//  final _saldoController = BehaviorSubject<double>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);


  // ponto de saída de dados do bloc  
  Stream<List> get outReceitas => _receitasController.stream; 

  // meu stream que vai dizer se estou salvando dados
  Stream<bool> get outLoading => _loadingController.stream;


  // uma mapa c/a ID da receita, e dentro ela um mapa c/seus dados
  Map<String, Map<String, dynamic>> _receitas = {};



  // isso e apens um simplificacao p/nao precisar ficar repetindo
  Firestore _firestore = Firestore.instance;

  // contrutor escuitador 
  ReceitasBloc(){
    appData.wtlSaldoAtu = 0.0;
    print("zerei wtl-saldo");
    _addReceitasListener();
  }

  

  void _addReceitasListener(){
    _firestore.collection("makers")
              .document(appData.uid)
              .collection("receitas").snapshots().listen((snapshot)

    {
      snapshot.documentChanges.forEach((change){
        String ruid = change.document.documentID;
        switch(change.type){
          case DocumentChangeType.added:
            _receitas[ruid] = change.document.data;
            _receitas[ruid]["id"] = ruid;
            _receitas[ruid]["visible"] =  _testaVisible(_receitas[ruid]);
            _recalcSaldo();
            _receitasController.add(_receitas.values.toList());
            break;

          case DocumentChangeType.modified:
            _receitas[ruid].addAll(change.document.data);
            _receitas[ruid]["id"] = ruid;
            _receitas[ruid]["visible"] =  _testaVisible(_receitas[ruid]);
            _recalcSaldo();
            _receitasController.add(_receitas.values.toList());
            break;

          case DocumentChangeType.removed:
            _receitas.remove(ruid);
            _recalcSaldo();
            _receitasController.add(_receitas.values.toList());
            break;
        }
      });
    });
  }


  _recalcSaldo(){
    appData.wtlTotRec = 0.0;
     void iterateMapEntry(key, value) {
      _receitas[key] = value;
      if(value["valor"] != null){
        appData.wtlTotRec = appData.wtlTotRec + value["valor"];
      }
    }
    _receitas.forEach(iterateMapEntry);
    appData.wtlSaldoAtu = appData.wtlTotRec - appData.wtlTotDesp;
}


 // exclusao de uma receita
 excluirReceita() async {
    _loadingController.add(true);
    await Firestore.instance.collection("makers")
    .document(appData.uid)
    .collection("receitas").document(appData.wtlRecId).delete();
    _loadingController.add(false);
 }



 // essa é a função que salva tudo no firebase
 // vai retornar um booleano do futuro dizendo se deu tudo certo
 Future<bool> saveReceita() async{
    // primeiro vamos avisar o controller q estamos em salvamento
    _loadingController.add(true);
    // // aqui faz 3 segundos de delay
    // await Future.delayed(Duration(seconds: 3));

      Map<String, dynamic> receitaData = {
        "clienteId": appData.wtlRecCli,
        "clienteNome": appData.wtlRecCliNome,
        "descricao": appData.wtlRecDsc,
        "valor": appData.wtlRecVlr,
        "data": (DateTime.now().day.toString().padLeft(2,"0") + "/" + 
                DateTime.now().month.toString().padLeft(2,"0") + "/" + 
                DateTime.now().year.toString().padLeft(2,"0") )
      };


    // salvamento no firebase Caraio!
    try{
      if(appData.wtlopc == "A") {  // quando  ja exite
         final String uid = appData.uid;
          await Firestore.instance
              .collection("makers")
              .document(uid)
              .collection("receitas")
              .document(appData.wtlRecId)
              .updateData(receitaData);

      } else {  // quando temos que criar um  novo reg
          final String uid = appData.uid;
            await Firestore.instance
                .collection("makers")
                .document(uid)
                .collection("receitas")
                .add(receitaData);
      }
      _loadingController.add(false);  // vamos informar que terminou o salvamento
      return true;   // e dizer que deu tudo certo

    }catch(e){   //quando der algum erro 
      _loadingController.add(false);
      return false;
    }

 }





// funcao ativada quando o tipo de filtro é alterado
void setFilterReceitas(String s){
   // vai percorrer os elementos do map
     void iterateMapEntry(key, value) {
      if(value["valor"] != null){
        _receitas[key]["visible"] =  _testaVisible(_receitas[key]);
      }
    }
    _receitas.forEach(iterateMapEntry);
    //aqui vamos devolver a lista
    _receitasController.add(_receitas.values.toList());
}


 //testa se receita vai ficar visivel ou nao
  bool _testaVisible(Map<String, dynamic> rec){
    var _dataRec = rdtDMA10toDate(rec["data"]);
    int _dias = DateTime.now().difference(_dataRec).inDays;
    if (appData.wtlFiltroFin == "T")
     return true;
    if (appData.wtlFiltroFin == "T")
     return true;
    if(_dias > int.parse(appData.wtlFiltroFin))
     return false; 
    else
     return true;
  }




  @override
  void dispose() {
    _receitasController.close();
    _loadingController.close();
  //  _saldoController.close();
    super.dispose();
  }


}
