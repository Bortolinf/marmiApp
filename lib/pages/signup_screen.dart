import 'package:flutter/material.dart';
import 'package:marmi_app/domain/logdata.dart';
import 'package:marmi_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';





class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // salva campo c/estado do Scaffold p/usar nas fnções lá de baixo
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoadging)
              return Center(child: CircularProgressIndicator(),);
            // se nao estiver carregando faz o codigo abaixo  
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Nome Completo"),
                    textCapitalization: TextCapitalization.words,
                    validator: (text) {
                      if (text.isEmpty) return "Nome Inválido"; else return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !text.contains("@"))
                        return "E-mail Inválido"; else return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha Inválida"; else return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(hintText: "Endereço"),
                    validator: (text) {
                      if (text.isEmpty) return "Endereço Inválido"; else return null;
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  // o sized box serviu aqui para deixar o botão mais alto
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                       shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(180.0)),
                      child: Text(
                        "Criar Conta",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          // a senha nao fica armazenada aqui pq vai ficar visivel no banco
                          Map<String, dynamic> userData = {
                            "name": _nameController.text.toString().trim(),
                            "email": _emailController.text.toString().trim(),
                            "address": _addressController.text.toString().trim(),
                          };
                          model.signUp(
                            userData: userData,
                            pass: _passController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            );
          },
        )
        );
  }


void _onSuccess(){
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text("Usuário criado com sucesso!"),
    backgroundColor: Theme.of(context).primaryColor,
    duration: Duration(seconds: 2),
    )
  );
  Future.delayed(Duration(seconds: 2)).then((_){
   //a) Navigator.of(context).pushReplacement(
   //   MaterialPageRoute(builder: (context)=>LoginScreen(String _emailController.text.toString().trim(), 
   //   String pass ))
   // );
   //b)  Navigator.of(context).pop();
    // c)
       Navigator.pop(context, LogData(email: _emailController.text, password: _passController.text));
    });
}

void _onFail(){
  _scaffoldKey.currentState.showSnackBar(
    SnackBar(content: Text("Falha ao criar usuario!"),
    backgroundColor: Colors.redAccent,
    duration: Duration(seconds: 2),
    )
  );
}


} // fim da bagaça toda
