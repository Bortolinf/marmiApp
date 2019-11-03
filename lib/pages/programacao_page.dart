import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/domain/singleton.dart';

class ProgramacaoPage extends StatefulWidget {
  @override
  _ProgramacaoPageState createState() => _ProgramacaoPageState();
}

class _ProgramacaoPageState extends State<ProgramacaoPage> {
// final ProgramacaoBloc _progrBloc = BlocProvider.getBloc<ProgramacaoBloc>();

  @override
  void initState() {
    _readData();
    appData.wtlDataProgr = DateTime.now().add(Duration(days: 1));
    _dateToX(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Programação Diária"),
      ),
      body: _body(context),
      bottomNavigationBar: _bottom(context),
    );
  }

  _bottom(context) {
    if (appData.wtlProgrDiaCli[appData.wtlDataProgrX] != null) {
      int totalPessoas = 0;
      for(Map m in appData.wtlProgrDiaCli[appData.wtlDataProgrX]){
        totalPessoas += m["pessoas"];
      }
      return SizedBox(
          height: 70,
          child: Container(
            color: Theme.of(context).accentColor,
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(
              "Total de Encomendas na data: ${appData.wtlProgrDiaCli[appData.wtlDataProgrX].length} \nTotal de Pessoas: $totalPessoas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ));
    }
  }

  _body(context) {
    print("data que cheguei: ${appData.wtlDataProgrX}");
    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                OutlineButton(
                  child: Icon(
                    Icons.navigate_before,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      appData.wtlDataProgr =
                          appData.wtlDataProgr.add(Duration(days: -1));
                      _dateToX(context);
                    });
                  },
                ),
                Text(
                  appData.wtlDataProgrX,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                OutlineButton(
                  child: Icon(Icons.navigate_next, size: 30),
                  onPressed: () {
                    setState(() {
                      appData.wtlDataProgr =
                          appData.wtlDataProgr.add(Duration(days: 1));
                      _dateToX(context);
                    });
                  },
                )
              ],
            ),
          ),
        ),
        _programacao(context),
      ],
    );
  }

  _programacao(context) {
    if (appData.wtlProgrDiaCli[appData.wtlDataProgrX] != null) {
      return Expanded(
        // child: SingleChildScrollView(
        // height: 200,
        child: ListView.builder(
          itemCount: appData.wtlProgrDiaCli[appData.wtlDataProgrX].length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card(
                  margin: EdgeInsets.fromLTRB(4, 2, 4, 2),
                            child: ListTile(
                  title: Text(
                    appData.wtlProgrDiaCli[appData.wtlDataProgrX][index]["nome"],
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    appData.wtlProgrDiaCli[appData.wtlDataProgrX][index]["obs"],
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(
                    appData.wtlProgrDiaCli[appData.wtlDataProgrX][index]["pessoas"].toString(),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

                  ),
                  dense: true,
                ),
              ),
            );
          },
        ),
        // ),
      );
    } else {
      return Center(
          child: Text(
        "sem Programação nesta data",
        style: TextStyle(fontSize: 18),
      ));
    }
  }

  _dateToX(context) {
    appData.wtlDataProgrX = appData.wtlDataProgr.day.toString() +
        "/" +
        appData.wtlDataProgr.month.toString() +
        "/" +
        appData.wtlDataProgr.year.toString();
  }

  _readData() async {
    appData.wtlProgrDiaCli = {};
    QuerySnapshot query = await Firestore.instance
        .collection("makers")
        .document(appData.uid)
        .collection("clientes")
        .getDocuments();

    //query.documents.map((d) => print(d));
    for (int i = 0; i < query.documents.length; i++) {
      DocumentSnapshot cli = query.documents[i];
      print(cli["nome"]);

      if (cli["programacao"] != null) {
        void iterateMapEntry(key, value) {
          cli["programacao"][key] = value;
          for (int d in value) {
            final String _data = d.toString() +
                "/" +
                key.substring(0, key.length - 4).toString() +
                "/" +
                key.substring(key.length - 4, key.length).toString();
            if (appData.wtlProgrDiaCli[_data] == null) {
              appData.wtlProgrDiaCli[_data] = [];
            }
            appData.wtlProgrDiaCli[_data].add({"nome":cli["nome"], "obs":cli["obs"], "pessoas":cli["pessoas"]});
          }
        }

        cli["programacao"].forEach(iterateMapEntry);
      }
    }
    setState(() {
      
    });
  }
} // fim de tudo
