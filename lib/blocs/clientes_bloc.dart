import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:rxdart/rxdart.dart';

class ClientesBloc extends BlocBase {

  final _clientesController = BehaviorSubject<List>();
  Stream<List> get outClientes => _clientesController.stream; 
  final _loadingController = BehaviorSubject<bool>.seeded(false);

  Map<String, Map<String, dynamic>> _clientes = {};

  // outClientes2 é o método mais simples de fazer o retorno do bloc c/dados do Firebase
  // porem este nao funcionava para fazer os filtros de pesquisa por nome
  Stream<List> outClientes2; 


  // meu stream que vai dizer se estou salvando dados
  Stream<bool> get outLoading => _loadingController.stream;


  // isso e apens um simplificacao p/nao precisar ficar repetindo
  Firestore _firestore = Firestore.instance;



  // contrutor escuitador 
  ClientesBloc(){

    // ativa metodo de varredura no firebase
    _addClientesListener();

  // declarando a consulta somente da primeira vez que esse bloc for criado
    outClientes2 =   _firestore.collection("makers")
              .document(appData.uid)
              .collection("clientes")
              .orderBy("nome") 
              .snapshots()
              // transformando os itens vindos do firestore em uma lista de document
              .map((e) => e.documents);

  }



  // funcao para quando for digitado o texto de busca
  void onChangedSearch(String search){
    if(search.trim().isEmpty){
      //sem filtro
      _clientesController.add(_clientes.values.toList());
    }else {
      _clientesController.add(_filter(search.trim()));
    }
  }

// funcao que faz o filtro e retorna apenas os dados que atendem a pesquisa
 //  tipo do   retorno     
 List<Map<String, dynamic>> _filter(String search){
     // copia para ela todo o conteudo da lista original de usuarios
   List<Map<String, dynamic>> filteredClientes = List.from(_clientes.values.toList());
     // essa funcao legalzona faz um teste que mantem na lista quem retornar true
    filteredClientes.retainWhere((cli){
        return cli["nome"].toUpperCase().contains(search.toUpperCase());
    } );
    // retorno da funcao
    return filteredClientes;
 }



  // funcao que iscuita - é chamada no contrutor
  // VAMOS LÁ: esta funcao esta escutando apenas as variacoes nos uruarios
  // aquele forEach recebe a relacao de cada mudança (change)
  // depois verifica qual o tipo de alteracao (inclusao/alteraca/exclusa)
  // e por fim faz o tratamento conforme o tipo de alteracao
  void _addClientesListener(){
     _firestore.collection("makers")
              .document(appData.uid)
              .collection("clientes")
              .orderBy("nome") 
              .snapshots().listen((snapshot){
      snapshot.documentChanges.forEach((change){
        print("Listenner : ${change.document.documentID}");
        String uid = change.document.documentID;
        switch(change.type){
          case DocumentChangeType.added:
            _clientes[uid] = change.document.data;
            _clientes[uid]["id"] = uid; 
            _clientesController.add(_clientes.values.toList());
            break;

          case DocumentChangeType.modified:
            _clientes[uid].addAll(change.document.data);
            // atualiza os dados do usu no Controller
            _clientesController.add(_clientes.values.toList());
            break;

          case DocumentChangeType.removed:
            _clientes.remove(uid);
            _clientesController.add(_clientes.values.toList());
            break;
        }
      });
    });
  }









 // exclusao de um registro
 excluirCliente() async {
    _loadingController.add(true);
   await Firestore.instance
                      .collection("makers")
                      .document(appData.uid)
                      .collection("clientes")
                      .document(appData.wtlCliId)
                      .delete();
    _loadingController.add(false);
 }



 // essa é a função que salva tudo no firebase
 // vai retornar um booleano do futuro dizendo se deu tudo certo
 Future<bool> saveCliente() async{
    // primeiro vamos avisar o controller q estamos em salvamento
    _loadingController.add(true);
    // // aqui faz 3 segundos de delay
    // await Future.delayed(Duration(seconds: 3));

      // usar essa que ja existe:
      Map<String, dynamic> clienteData = clientewtlToMap();


     // Map<String, dynamic> clienteData = {
     //     "nome": appData.wtlCliNom,
     //     "endereco": appData.wtlCliEnd,
     //     "telefone": appData.wtlCliTel,
     //     "obs": appData.wtlCliObs,
     //     "pessoas": appData.wtlCliPess
     // };


    // salvamento no firebase Caraio!
    try{
      if(appData.wtlopc == "A") {  // quando  ja exite
          await Firestore.instance
              .collection("makers")
              .document(appData.uid)
              .collection("clientes")
              .document(appData.wtlCliId)
              .updateData(clienteData);

      } else {  // quando temos que criar um  novo reg
            await Firestore.instance
                .collection("makers")
                .document(appData.uid)
                .collection("clientes")
                .add(clienteData);
      }
      _loadingController.add(false);  // vamos informar que terminou o salvamento
      return true;   // e dizer que deu tudo certo

    }catch(e){   //quando der algum erro 
      _loadingController.add(false);
      return false;
    }

 }



  @override
  void dispose() {
    _clientesController.close();
    _loadingController.close();
    super.dispose();
  }


}

