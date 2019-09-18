import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

// um Model é um objeto que vai guardar os estados de alguma coisa, capici?
class UserModel extends Model {
  
  // isto é um sigleton p/nao precisar ficar reescrevendo FirebaseAuth.instance
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();
  
  bool isLoadging = false;
  
  // isso é para permitir acessar o UserModel de outras telas sem precisar
  // criar o ScopedModel
  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

 @override
 void addListener(VoidCallback listener) {
   super.addListener(listener);
 }


  void signUp({@required Map<String, dynamic> userData, @required String pass, 
               @required VoidCallback onSuccess, @required VoidCallback onFail}){
    isLoadging = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
      email: userData["email"].toString().trim(),
      password: pass
      // login OK
      ).then((authResult) async{
        firebaseUser = authResult.user;
        // manda salvar os outros dados do user (endereço, etc)
        await _saveUserData(userData);

        onSuccess();
        isLoadging = false;
        notifyListeners();
     
      // login com problema
      }).catchError((e){
        onFail();
        isLoadging = false;
        notifyListeners();
      });
  }

  void signIn({@required String email, @required String pass, 
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoadging = true;
    notifyListeners();
    _auth.signInWithEmailAndPassword(email: email, password: pass).then(
      (authResult) async{
        firebaseUser = authResult.user;
        await _loadCurrentUser();

        onSuccess();
        isLoadging = false;
        notifyListeners();

      }).catchError((e){
        onFail();
        isLoadging = false;
        notifyListeners();
      })
      
      ;

    // await Future.delayed(Duration(seconds: 3));
    isLoadging = false;
    notifyListeners();
  }



  void meLoguei(FirebaseUser fbuser)  {
        firebaseUser = fbuser;
        notifyListeners();
  }






  void signOut()async{
   await _auth.signOut();
   userData = Map();
   firebaseUser = null;
   notifyListeners();
  }


  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }


  Future<Null> _saveUserData(Map<String, dynamic> userdata) async{
    this.userData = userdata;
    await Firestore.instance.collection("makers").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    if (firebaseUser == null)
     firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = 
        await Firestore.instance.collection("makers").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }





  void tenteLogar() async {
       await _loadCurrentUser();
       if(firebaseUser != null)
        isLoadging = false;
        notifyListeners();
  }





} // fim de tudo

