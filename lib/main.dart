import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/pages/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'blocs/clientes_bloc.dart';
import 'blocs/despesas_bloc.dart';
import 'blocs/receitas_bloc.dart';
import 'models/user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      blocs: [
        Bloc((i) => ClientesBloc()),
        Bloc((i) => DespesasBloc()),
        Bloc((i) => ReceitasBloc()),
      ],
      child: ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [
              const Locale('pt', 'BR')
            ],
            key: Key('materialapp'),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.pink[100],
              accentColor: Colors.lightBlue[200],
            ),
            //    home: LoginPage()
            home: LoginScreen()),
      ),
    );
  }
}
