import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marmi_app/blocs/clientes_bloc.dart';
import 'package:marmi_app/domain/singleton.dart';

class EditClientePage extends StatefulWidget {
  EditClientePage();

  @override
  _EditClientePageState createState() => _EditClientePageState();
}

class _EditClientePageState extends State<EditClientePage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final ClientesBloc _clientesBloc = BlocProvider.getBloc<ClientesBloc>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appData.wtlopc == "I" ? "Incluir Cliente" : "Editar Cliente",
          style: TextStyle(color: Colors.grey[800]),
        ),
      ),
      body: _formEdtCliente(context),
    );
  }

  _formEdtCliente(context) {
    print("exibimos o form");
    return ListView(
      padding: EdgeInsets.all(25),
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          initialValue: appData.wtlopc == "A"
              ? {
                  "nome": appData.wtlCliNom,
                  "endereco": appData.wtlCliEnd,
                  "telefone": appData.wtlCliTel,
                  "obs": appData.wtlCliObs,
                  "pessoas": appData.wtlCliPess.toString()
                }
              : {},
          //clientewtlToMap() : " ", - tentei chamar via funcao
          autovalidate: true,
          child: Column(children: <Widget>[
            FormBuilderTextField(
                attribute: "nome",
                decoration: InputDecoration(labelText: "Nome:"),
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(errorText: "Informar o Nome")
                ]),
            FormBuilderTextField(
                attribute: "endereco",
                decoration: InputDecoration(labelText: "Endereço:"),
                textCapitalization: TextCapitalization.words,
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Informar o Endereço")
                ]),
            FormBuilderTextField(
                attribute: "telefone",
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Telefone:",
                ),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Informar o Telefone")
                ]),
            FormBuilderTextField(
              attribute: "obs",
              decoration: InputDecoration(labelText: "Observação:"),
                textCapitalization: TextCapitalization.words,
            ),
            FormBuilderTextField(
                attribute: "pessoas",
                decoration: InputDecoration(labelText: "Nro. de Pessoas:"),
                keyboardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.min(1, errorText: "No mínimo 1 pessoa"),
                  FormBuilderValidators.required(
                      errorText: "Informar número de pessoas")
                ]),
          ]),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 45,
          child: StreamBuilder<bool>(
              initialData: false,
              stream: _clientesBloc.outLoading,
              builder: (context, snapshot) {
                return RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(180.0)),
                  color: Theme.of(context).accentColor,
                  child: snapshot.data
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                        )
                      : Text("Salvar"),
                  onPressed: snapshot.hasData
                      ? () async {
                          _fbKey.currentState.save();
                          if (_fbKey.currentState.validate()) {
                            Map result = _fbKey.currentState.value;
                            appData.wtlCliNom = result["nome"];
                            appData.wtlCliEnd = result["endereco"];
                            appData.wtlCliTel = result["telefone"];
                            appData.wtlCliObs = result["obs"];
                            appData.wtlCliPess = int.parse(result["pessoas"]);
                            await _clientesBloc.saveCliente();
                            Navigator.of(context).pop();
                          }
                        }
                      : null,
                );
              }),
        )
      ],
    );
  }
} // fim de tudo
