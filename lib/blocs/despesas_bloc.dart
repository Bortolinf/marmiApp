import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/utils/date_utils.dart';
import 'package:rxdart/rxdart.dart';

class DespesasBloc extends BlocBase {

  final _despesasController = BehaviorSubject<List>();
//  final _saldoController = BehaviorSubject<double>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);


  // ponto de saída de dados do bloc  
  Stream<List> get outDespesas => _despesasController.stream; 


  // meu stream que vai dizer se estou salvando dados
  Stream<bool> get outLoading => _loadingController.stream;


  // uma mapa c/a ID da despesa, e dentro ela um mapa c/seus dados
  Map<String, Map<String, dynamic>> _despesas = {};



  // isso e apens um simplificacao p/nao precisar ficar repetindo
  Firestore _firestore = Firestore.instance;

  // contrutor escuitador 
  DespesasBloc(){
    appData.wtlTotDesp = 0.0;
    print("zerei wtl-saldo");
    _addDespesasListener();
  }


  // funcao que iscuita - é chamada no contrutor
  // VAMOS LÁ: esta funcao esta escutando apenas as variacoes nos uruarios
  // aquele forEach recebe a relacao de cada mudança (change)
  // depois verifica qual o tipo de alteracao (inclusao/alteraca/exclusa)
  // e por fim faz o tratamento conforme o tipo de alteracao
  void _addDespesasListener(){
    _firestore.collection("makers")
              .document(appData.uid)
              .collection("despesas").snapshots().listen((snapshot)

    {
      snapshot.documentChanges.forEach((change){
        String duid = change.document.documentID;
        switch(change.type){
          case DocumentChangeType.added:
            _despesas[duid] = change.document.data;
            _despesas[duid]["id"] = duid;
            _despesas[duid]["visible"] =  _testaVisible(_despesas[duid]);
            _recalcSaldo();
            _despesasController.add(_despesas.values.toList());
            break;

          case DocumentChangeType.modified:
            _despesas[duid].addAll(change.document.data);
            _despesas[duid]["id"] = duid;
            _despesas[duid]["visible"] =  _testaVisible(_despesas[duid]);
            _recalcSaldo();
            _despesasController.add(_despesas.values.toList());
            break;

          case DocumentChangeType.removed:
            _despesas.remove(duid);
            _recalcSaldo();
            _despesasController.add(_despesas.values.toList());
            break;
        }
      });
    });
  }


 



  _recalcSaldo(){
    appData.wtlTotDesp = 0.0;
     void iterateMapEntry(key, value) {
      _despesas[key] = value;
      if(value["valor"] != null){
        appData.wtlTotDesp = appData.wtlTotDesp + value["valor"];
      }
    }
    _despesas.forEach(iterateMapEntry);
    appData.wtlSaldoAtu = appData.wtlTotRec - appData.wtlTotDesp;
}


 // exclusao de uma despesa
 excluirDespesa() async {
    _loadingController.add(true);
    await Firestore.instance.collection("makers")
    .document(appData.uid)
    .collection("despesas").document(appData.wtlDespId).delete();
    _loadingController.add(false);
 }



 // essa é a função que salva tudo no firebase
 // vai retornar um booleano do futuro dizendo se deu tudo certo
 Future<bool> saveDespesa() async{
    // primeiro vamos avisar o controller q estamos em salvamento
    _loadingController.add(true);
    // // aqui faz 3 segundos de delay
    // await Future.delayed(Duration(seconds: 3));

      Map<String, dynamic> despesaData = {
        "descricao": appData.wtlDespDsc,
        "valor": appData.wtlDespVlr,
        "data": (DateTime.now().day.toString().padLeft(2,"0") + "/" + 
                DateTime.now().month.toString().padLeft(2,"0") + "/" + 
                DateTime.now().year.toString().padLeft(2,"0") )
      };


    // salvamento no firebase Caraio!
    try{
      if(appData.wtlopc == "A") {  // quando produto ja exite
         final String uid = appData.uid;
          await Firestore.instance
              .collection("makers")
              .document(uid)
              .collection("despesas")
              .document(appData.wtlDespId)
              .updateData(despesaData);

      } else {  // quando temos que criar um produto novo
          final String uid = appData.uid;
            await Firestore.instance
                .collection("makers")
                .document(uid)
                .collection("despesas")
                .add(despesaData);
      }
      _loadingController.add(false);  // vamos informar que terminou o salvamento
      return true;   // e dizer que deu tudo certo

    }catch(e){   //quando der algum erro 
      _loadingController.add(false);
      return false;
    }

 }



// funcao ativada quando o tipo de filtro é alterado
void setFilterDespesas(String s){
   // vai percorrer os elementos do map
     void iterateMapEntry(key, value) {
      if(value["valor"] != null){
        _despesas[key]["visible"] =  _testaVisible(_despesas[key]);
      }
    }
    _despesas.forEach(iterateMapEntry);
    //aqui vamos devolver a lista
    _despesasController.add(_despesas.values.toList());
}


 //testa se despesa vai ficar visivel ou nao
  bool _testaVisible(Map<String, dynamic> desp){
    var _dataDesp = rdtDMA10toDate(desp["data"]);
    int _dias = DateTime.now().difference(_dataDesp).inDays;
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
    _despesasController.close();
    _loadingController.close();
  //  _saldoController.close();
    super.dispose();
  }


}
