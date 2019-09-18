import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marmi_app/blocs/despesas_bloc.dart';
import 'package:marmi_app/domain/singleton.dart';

class EditDespesaDialog extends StatefulWidget {
  @override
  _EditDespesaDialogState createState() => _EditDespesaDialogState();
}

class _EditDespesaDialogState extends State<EditDespesaDialog> {
  final GlobalKey<FormBuilderState> _fmDpsKey = GlobalKey<FormBuilderState>();

  final DespesasBloc _despesasBloc = BlocProvider.getBloc<DespesasBloc>();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(appData.wtlopc == "I" ? "Incluir Depesa" : "Alterar Despesa"),
            _botaoDelete(context),
          ],
        ),
        contentPadding: EdgeInsets.all(8),
        children: [
          FormBuilder(
            key: _fmDpsKey,
            initialValue: appData.wtlopc == "A"
                ? {
                    "descricao": appData.wtlDespDsc,
                    "valor": appData.wtlDespVlr.toString()
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
                  decoration: InputDecoration(labelText: "Valor Pago"),
                  keyboardType: TextInputType.number,
                  validators: [
                    FormBuilderValidators.min(1, errorText: "Informar o Valor"),
                    FormBuilderValidators.required(
                        errorText: "Informar o Valor")
                  ]),
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
                  stream: _despesasBloc.outLoading,
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
                                appData.wtlDespDsc = result["descricao"];
                                appData.wtlDespVlr =
                                    double.parse(result["valor"]);
                                await _despesasBloc.saveDespesa();
                                Navigator.of(context).pop();
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

  _botaoDelete(context) {
    if (appData.wtlopc == "A") {
      return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          await _despesasBloc.excluirDespesa();
          Navigator.of(context).pop();
        },
      );
    } else {
      return Container();
    }
  }
} // fim de tudo
