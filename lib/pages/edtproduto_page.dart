import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/models/produto_model.dart';

class EditProdutoPage extends StatefulWidget {
  EditProdutoPage();

  @override
  _EditProdutoPageState createState() => _EditProdutoPageState();
}

class _EditProdutoPageState extends State<EditProdutoPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var _progress = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appData.wtlopc == "I" ? "Incluir Produto" : "Editar Produto",
          style: TextStyle(color: Colors.grey[800]),
        ),
      ),
      body: _formEdtProduto(context),
    );
  }

  _formEdtProduto(context) {
    print("exibimos o form");
    return ListView(
      padding: EdgeInsets.all(25),
      children: <Widget>[
        FormBuilder(
          key: _fbKey,
          initialValue: appData.wtlopc == "A"
              ? {
                  "descricao": appData.wtlPrdDsc,
                  "valor": appData.wtlPrdVlr.toString()
                }
              : {},
          //produtowtlToMap() : " ", - tentei chamar via funcao
          autovalidate: true,
          child: Column(children: <Widget>[
            FormBuilderTextField(
                attribute: "descricao",
                decoration: InputDecoration(labelText: "Descrição:"),
                validators: [
                  FormBuilderValidators.required(
                      errorText: "Informar a Descrição")
                ]),
            FormBuilderTextField(
                attribute: "valor",
                decoration: InputDecoration(labelText: "Preço:"),
                keyboardType: TextInputType.number,
                validators: [
                  FormBuilderValidators.min(1, errorText: "Informar o Preço"),
                  FormBuilderValidators.required(errorText: "Informar o preço")
                ]),
          ]),
        ),
        SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 45,
          child: RaisedButton(
             shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(180.0)),
            color: Theme.of(context).accentColor,
            child: _progress
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )
                : Text(
                    "Salvar",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
            onPressed: () {
              _fbKey.currentState.save();
              if (_fbKey.currentState.validate()) {
                Map result = _fbKey.currentState.value;
                appData.wtlPrdDsc = result["descricao"];
                appData.wtlPrdVlr = double.parse(result["valor"]);
                _onClickCadastrar(context);
              }
            },
          ),
        )
      ],
    );
  }

  _onClickCadastrar(context) async {
    setState(() {
      _progress = true;
    });

    await salvarProduto(
      onFail: () {},
      onSuccess: () {
        Navigator.pop(context);
        if (appData.wtlopc == "A") {
          Navigator.pop(context);
        }
      },
    );

    setState(() {
      _progress = false;
    });
  }
} // fim de tudo
