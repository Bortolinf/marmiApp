import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/domain/logdata.dart';
import 'package:marmi_app/domain/singleton.dart';
import 'package:marmi_app/models/user_model.dart';
import 'package:marmi_app/pages/signup_screen.dart';
import 'package:marmi_app/utils/nav.dart';
import 'package:scoped_model/scoped_model.dart';

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: "teste@gmail.com");
  final _passController = TextEditingController(text: "123456");
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var _progress = false;

// ver se ja esta logado ao entrar aqui nesta tela
  @override
  void initState() {
    super.initState();
      getUser().then((user) {
      if (user != null) {
        UserModel.of(context).firebaseUser = user;
        _onSuccess();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoadging)
              return Center(
                child: CircularProgressIndicator(),
              );

            if (model.isLoggedIn()) {
              // 22/08/2019
              //pushReplacement(context, HomePage(UserModel.of(context).firebaseUser.uid));
              // essas duas linhas deram erro
              //appData.uid = UserModel.of(context).firebaseUser.uid;
              //pushReplacement(context, HomePage());
            }

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset("assets/images/back.png", fit: BoxFit.cover),
                Container(
                  color: Colors.brown[800].withOpacity(0.7),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset(
                          "assets/images/logo.png",
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(
                          height: 30,
                        ),

                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              border: null,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 18),
                            decoration: //null,
                                InputDecoration(
                                    icon: Icon(Icons.email),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                            keyboardType: TextInputType.emailAddress,
                            validator: (text) {
                              if (text.isEmpty || !text.contains("@"))
                                return "E-mail Inválido";
                              else
                                return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              border: null,
                              borderRadius: BorderRadius.circular(30)),
                          child: TextFormField(
                            controller: _passController,
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 18),
                            decoration: //null,
                                InputDecoration(
                                    icon: Icon(Icons.vpn_key),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none),
                            obscureText: true,
                            validator: (text) {
                              if (text.isEmpty || text.length < 6)
                                return "Senha Inválida";
                              else
                                return null;
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            onPressed: () {
                              if (_emailController.text.isEmpty)
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Insira seu e-mail para recuperação!"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                ));
                              else {
                                model.recoverPass(_emailController.text);
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text("Confira seu e-mail"),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            },
                            child: Text(
                              "Esqueci minha senha",
                              textAlign: TextAlign.right,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        // o sized box serviu aqui para deixar o botão mais alto
                        SizedBox(
                          height: 55.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(180.0)),
                            child: _progress
                                ? CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : Text(
                                    "Entrar",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                            textColor: Colors.white,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            onPressed: () {
                              setState(() {
                                _progress = true;
                              });
                              if (_formKey.currentState.validate()) {}
                              model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          height: 40.0,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(180.0)),
                              child: Text(
                                "Criar Nova Conta",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6),
                              onPressed: () async {
                                final logData = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                ) as LogData;
                                setState(() {
                                  _emailController.text = logData.email;
                                  _passController.text = logData.password;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ));
  }

  void _onSuccess() {
    _progress = false;
    appData.uid = UserModel.of(context).firebaseUser.uid;
    //_salvarLogin();
    pushReplacement(context, HomePage());
  }

  void _onFail() {
    setState(() {
      _progress = false;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  
} // final de tudo
