import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marmi_app/blocs/clientes_bloc.dart';
import 'package:marmi_app/blocs/receitas_bloc.dart';
import 'package:marmi_app/domain/marmi.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/utils/nav.dart';

import 'calendar_cli_rec.dart';

class EditReceitaDialog extends StatefulWidget {
  @override
  _EditReceitaDialogState createState() => _EditReceitaDialogState();
}

class _EditReceitaDialogState extends State<EditReceitaDialog> {
  final GlobalKey<FormBuilderState> _fmDpsKey = GlobalKey<FormBuilderState>();

  final ReceitasBloc _receitasBloc = BlocProvider.getBloc<ReceitasBloc>();
  final ClientesBloc _cliBloc = BlocProvider.getBloc<ClientesBloc>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(appData.wtlopc == "I" ? "Incluir Receita" : "Alterar Receita"),
            _botaoDelete(context),
          ],
        ),
        contentPadding: EdgeInsets.all(8),
        children: [
          FormBuilder(
            key: _fmDpsKey,
            initialValue: appData.wtlopc == "A"
                ? {
                    "descricao": appData.wtlRecDsc,
                    "valor": appData.wtlRecVlr.toString(),
                  }
                : {},
            autovalidate: true,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              FormBuilderTextField(
                  attribute: "descricao",
                  decoration: InputDecoration(labelText: "Descrição:"),
                  textCapitalization: TextCapitalization.words,
                  validators: [
                    FormBuilderValidators.required(
                        errorText: "Informar a Descrição")
                  ]),
              FormBuilderTextField(
                  attribute: "valor",
                  decoration: InputDecoration(labelText: "Valor Recebido"),
                  keyboardType: TextInputType.number,
                  validators: [
                    FormBuilderValidators.min(1, errorText: "Informar o Valor"),
                    FormBuilderValidators.required(
                        errorText: "Informar o Valor")
                  ]),
              _selecaoCliente(context),
            ]),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              StreamBuilder<bool>(
                  initialData: false,
                  stream: _receitasBloc.outLoading,
                  builder: (context, snapshot) {
                    return OutlineButton(
                      child: snapshot.data
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.pinkAccent),
                            )
                          : Text("Salvar"),
                      onPressed: snapshot.hasData
                          ? () async {
                              _fmDpsKey.currentState.save();
                              if (_fmDpsKey.currentState.validate()) {
                                Map result = _fmDpsKey.currentState.value;
                                appData.wtlRecDsc = result["descricao"];
                                appData.wtlRecVlr =
                                    double.parse(result["valor"]);
                                await _receitasBloc.saveReceita();
                                Navigator.of(context).pop();
                                push(context, CalendarCliRec());
                              }
                            }
                          : null,
                    );
                  }),
              OutlineButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ]);
  }

  _selecaoCliente(context) {
    return StreamBuilder<List>(
        initialData: [],
        stream: _cliBloc.outClientes2,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("erro snapshot lista cli");
            return Container();
          } else if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Colors.white,
                ),
              ),
            );
          } else
            print(appData.wtlRecCliNome);
          return  FormBuilderDropdown(
            onChanged: ((cli) {
              ClienteData cliente = cli;
              cliente.toWtl();
              appData.wtlRecCli = cliente.id;
              appData.wtlRecCliNome = cliente.nome;
              print(cliente);
            }),
            attribute: "cliente",
            decoration: InputDecoration(labelText: "Selecionar Cliente"),
            validators: [
              FormBuilderValidators.required(errorText: "informar cliente")
            ],
            items: snapshot.data.map((cli) {
              ClienteData data = ClienteData.fromDocument(cli);
              // print("nome: ${data.nome}");
              return DropdownMenuItem(
                child: Text(data.nome),
                value: data,
              );
            }).toList(),
           // initialValue: appData.wtlRecCliNome,

          );
        });
  } // fim selecaoCliente

// fim selecaoClienteBas

  _botaoDelete(context) {
    if (appData.wtlopc == "A") {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await _receitasBloc.excluirReceita();
          Navigator.of(context).pop();
        },
      );
    } else {
      return Container();
    }
  }
} // fim de tudo
