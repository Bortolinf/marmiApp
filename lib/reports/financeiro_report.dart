import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';


void financeiroReport(int dias, bool geraReceita, bool geraDespesa)  async {

 // int dias;
  print("cheguei no repor financeiro c/ $dias dias");

  final Document pdf = Document();

  List <String> cabRec = [];
  List <String> cabDesp = [];
  List <String> cabDadosRec = [];
  List <String> cabDadosDesp = [];
  List <List<String>> relatoDesp = [];
  List <List<String>> relatoRec = [];

  
  // colunas do cabeçalho - Receitas
  cabRec.add("Data");
  cabRec.add("Cliente");
  cabRec.add("Obs");
  cabRec.add("Valor");

  // colunas do cabeçalho - Despesas
  cabDesp.add("Data");
  cabDesp.add("Descrição");
  cabDesp.add("Valor");


  relatoDesp.add(cabDesp);
  relatoRec.add(cabRec);


 // aqui vai pegar dados das Despesas
  if (geraDespesa) {
    double totalDesp = 0.0; 
  QuerySnapshot cliQuery = await Firestore.instance.collection("makers")
              .document(appData.uid)
              .collection("despesas")
              .orderBy("data") 
              .getDocuments();

  cliQuery.documents.forEach((desp){
    if (_testaVisible(desp, dias)) {
      cabDadosDesp = [];
      cabDadosDesp.add(DateFormat('dd-MM-yyyy').format(desp["data"].toDate()));
      cabDadosDesp.add(desp["descricao"]);
      totalDesp += desp["valor"];
      cabDadosDesp.add(desp["valor"].toStringAsFixed(2));
      relatoDesp.add(cabDadosDesp);
    }
  });
      // linha do total
      cabDadosDesp = [];
      cabDadosDesp.add("TOTAL");
      cabDadosDesp.add("");
      cabDadosDesp.add(totalDesp.toStringAsFixed(2));
      relatoDesp.add(cabDadosDesp);

  } // fim do teste geraDespesa




 // aqui vai pegar dados das Receitas
  if (geraReceita) {
    double totalRec = 0.0;
  QuerySnapshot cliQuery = await Firestore.instance.collection("makers")
              .document(appData.uid)
              .collection("receitas")
              .orderBy("data") 
              .getDocuments();

  cliQuery.documents.forEach((rec){
    if (_testaVisible(rec, dias)) {
        cabDadosRec = [];
        cabDadosRec.add(DateFormat('dd-MM-yyyy').format(rec["data"].toDate()));
        cabDadosRec.add(rec["clienteNome"] ?? "");
        cabDadosRec.add(rec["descricao"]);
        cabDadosRec.add(rec["valor"].toStringAsFixed(2));
        totalRec += rec["valor"];
        relatoRec.add(cabDadosRec);
    }
  });
  // linha do total
        cabDadosRec = [];
        cabDadosRec.add("TOTAL");
        cabDadosRec.add("");
        cabDadosRec.add("");
        cabDadosRec.add(totalRec.toStringAsFixed(2));
        relatoRec.add(cabDadosRec);

  } // fim do teste geraReceita




  // monta estrutura do documento PDF
  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const BoxDecoration(
                border:
                    BoxBorder(bottom: true, width: 0.5, color: PdfColors.grey)),
            child: Text('Movimentação Financeira',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Movimentação Financeira', textScaleFactor: 2),
                      PdfLogo()
                    ])),
            geraDespesa ?  Header(level: 1, text: 'Despesas') : Container(),
            geraDespesa ? Paragraph(
                text:
                    "Vamos colocar aqui em baixo uma relação das suas despesas")
                    : Container(),
            geraDespesa ? Table.fromTextArray(context: context, data: relatoDesp) : Container(),        

            geraReceita ?  Header(level: 1, text: 'Receitas') : Container(),
            geraReceita ? Paragraph(
                text:
                    "Vamos colocar aqui em baixo uma relação das suas receitas")
                    : Container(),
            geraReceita ? Table.fromTextArray(context: context, data: relatoRec) : Container(),        


            Padding(padding: const EdgeInsets.all(10)),
            Paragraph(
                text:
                    'Relatório Gerado por marmiApp')
          ]));

 Directory appDocDir = await getApplicationDocumentsDirectory();
 var targetFileName = appDocDir.path + "/financas-pdf";
 print(targetFileName);
    
  final File file = File(targetFileName);
  file.writeAsBytesSync(pdf.save());

  OpenFile.open(targetFileName);
  
} // fim de tudo




// testa se a data do lancamento deve ser exibida
bool _testaVisible(DocumentSnapshot desp, int dias){
  int _dias = DateTime.now().difference(desp["data"].toDate()).inDays;
  if(_dias > dias)
    return false; 
  else
    return true;
}