import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:rxdart/rxdart.dart';

class ProgramacaoBloc extends BlocBase {
  // final _programacaoController = BehaviorSubject<List>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);

  // ponto de saída de dados do bloc
  //Future<List<dynamic>> outProgramacao; //=> _programacaoController.stream;

  // meu stream que vai dizer se estou salvando dados
  Stream<bool> get outLoading => _loadingController.stream;

  // uma mapa c/a ID a Data, e dentro dela um mapa c/seus dados
  // Map<String, Map<String, dynamic>> _programacao = {};
  Map<String, List> _programacao = {};

  // isso e apens um simplificacao p/nao precisar ficar repetindo
  Firestore _firestore = Firestore.instance;

  // contrutor escuitador
  ProgramacaoBloc() {
   // _readData();
      _loadingController.add(true);
       _addProgramacaoListener();
      _loadingController.add(false);
  }

  _readData() {
    _loadingController.add(true);
    appData.wtlProgrDiaCli = {};
    _firestore
        .collection("makers")
        .document(appData.uid)
        .collection("clientes")
        .snapshots()
        .map((p) {
      p.documents.map((p2) {
        if (p2["programacao"] != null) {
          void iterateMapEntry(key, value) {
            p2["programacao"][key] = value;
            for (int d in value) {
              final String _data = d.toString() +
                  "/" +
                  key.substring(0, key.length - 4).toString() +
                  "/" +
                  key.substring(key.length - 4, key.length).toString();
              if (appData.wtlProgrDiaCli[_data] == null) {
                appData.wtlProgrDiaCli[_data] = [];
              }
              appData.wtlProgrDiaCli[_data].add(p2["nome"]);
            }
          }

          p2["programacao"].forEach(iterateMapEntry);
        }
      });
    });
    _loadingController.add(false);
  }

  void _addProgramacaoListener() {
    _firestore
        .collection("makers")
        .document(appData.uid)
        .collection("clientes")
        .snapshots()
        .listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.document.data["programacao"] != null) {
              void iterateMapEntry(key, value) {
                change.document.data["programacao"][key] = value;
                //   print('$key:$value');//string interpolation in action
                for (int d in value) {
                  final String _data = d.toString() +
                      "/" +
                      key.substring(0, key.length - 4).toString() +
                      "/" +
                      key.substring(key.length - 4, key.length).toString();
                  if (appData.wtlProgrDiaCli[_data] == null) {
                    appData.wtlProgrDiaCli[_data] = [];
                  }
                  appData.wtlProgrDiaCli[_data].add(change.document.data["nome"]);
                }
              }

              // pra cada mapa faz a rotina acima
              change.document.data["programacao"].forEach(iterateMapEntry);
            }
            //    _programacaoController.add(_programacao.values.toList());
            break;

          // TIREI POR ENQUANTO PQ NAO SEI COMO FAZER
          case DocumentChangeType.modified:
            //      _programacao[duid].addAll(change.document.data);
            //      _programacao[duid]["id"] = duid;
            //      _programacao[duid]["visible"] =  _testaVisible(_programacao[duid]);
            //      _recalcSaldo();
            //      _programacaoController.add(_programacao.values.toList());
            break;

          case DocumentChangeType.removed:
            //      _programacao.remove(duid);
            //      _recalcSaldo();
            //      _programacaoController.add(_programacao.values.toList());
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    // _programacaoController.close();
    _loadingController.close();
    super.dispose();
  }
}
