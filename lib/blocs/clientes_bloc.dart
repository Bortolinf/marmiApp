import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:rxdart/rxdart.dart';

class ClientesBloc extends BlocBase {

  final _clientesController = BehaviorSubject<List>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);


  Stream<List> outClientes2; 


  // meu stream que vai dizer se estou salvando dados
  Stream<bool> get outLoading => _loadingController.stream;


  // isso e apens um simplificacao p/nao precisar ficar repetindo
  Firestore _firestore = Firestore.instance;

  // contrutor escuitador 
  ClientesBloc(){

  // declarando a consulta somente da primeira vez que esse bloc for criado
    outClientes2 =   _firestore.collection("makers")
              .document(appData.uid)
              .collection("clientes")
              .orderBy("nome") 
              .snapshots()
              // transformando os itens vindos do firestore em uma lista de document
              .map((e) => e.documents);
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

