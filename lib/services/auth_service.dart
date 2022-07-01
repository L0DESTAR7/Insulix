import 'package:firebase_auth/firebase_auth.dart';
import 'package:insulix/models/insulixUser.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  InsulixUser insulixUserFromFirebaseUser (User? user) {
    if (user != null){
      return InsulixUser(UID: user.uid);
    }
    else{
      return InsulixUser(UID: "0");
    }
  }

  Stream<InsulixUser> get user {
    return _auth.authStateChanges().map(insulixUserFromFirebaseUser);
  }


  Future signInWithEmailAndPassword (String email, String password) async{
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return insulixUserFromFirebaseUser(user);
    } on FirebaseAuthException catch (e){
      print("Authentication error!");
      print(e.code);
      return null;
    }
  }

  Future signUpWithEmailAndPassword (String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return insulixUserFromFirebaseUser(user);
    } catch (e){
      print("REGISTRATION ERROR!");
      print(e);
      return null;
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e) {
      print("ERROR IN SIGNING OUT!");
    }
  }
}