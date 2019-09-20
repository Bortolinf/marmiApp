import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

void clientesReport()  async {

  final Document pdf = Document();

  // colunas do cabeçalho
  List <String> cab = [];
  cab.add("Nome");
  cab.add("Endereço");
  cab.add("Telefone");

  List <String> cabDados = [];

  List <List<String>> relato = [];
  relato.add(cab);
 // aqui vai pegar dados dos clientes do Bloc

  QuerySnapshot cliQuery = await Firestore.instance.collection("makers")
              .document(appData.uid)
              .collection("clientes")
              .orderBy("nome") 
              .getDocuments();

  cliQuery.documents.forEach((cli){
    cabDados = [];
    cabDados.add(cli["nome"]);
    cabDados.add(cli["endereco"]);
    cabDados.add(cli["telefone"]);
    relato.add(cabDados);
  });



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
            child: Text('Relação de Clientes',
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
                      Text('Seus Clientes', textScaleFactor: 2),
                      FlutterLogo()
                    ])),
            Header(level: 1, text: 'Clientes'),
            Table.fromTextArray(context: context, data: relato),
            Padding(padding: const EdgeInsets.all(10)),
            Paragraph(
                text:
                    'Relatório Gerado por marmiApp')
          ]));

 Directory appDocDir = await getApplicationDocumentsDirectory();
 var targetFileName = appDocDir.path + "/example-pdf";
 print(targetFileName);
    
  final File file = File(targetFileName);
  file.writeAsBytesSync(pdf.save());

  OpenFile.open(targetFileName);
  
}