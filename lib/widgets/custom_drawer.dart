import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marmi_app/pages/login_screen.dart';
import 'package:marmi_app/utils/nav.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:marmi_app/models/user_model.dart';

class CustomDrawer extends StatelessWidget {
  final BuildContext context;
  CustomDrawer(this.context);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: Icon(Icons.person, size: 80,),
            accountName: FutureBuilder<FirebaseUser>(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return Text(user.displayName);
                  } else return null;
                }),
            accountEmail: FutureBuilder<FirebaseUser>(
                future: FirebaseAuth.instance.currentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final user = snapshot.data;
                    return Text(user.email);
                  } else return null;
                }),
          ),
          ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              return ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text("Fazer LogOff"),
                onTap: () {
                  model.signOut();
                 // final service = FirebaseService();
                //  final response = service.logout();
                  pushReplacement(context, LoginScreen());
                },
              );
            },
          )
        ],
      ),
    );
  }
}
