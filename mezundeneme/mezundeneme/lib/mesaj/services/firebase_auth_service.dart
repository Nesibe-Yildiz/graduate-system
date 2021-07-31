import 'package:firebase_auth/firebase_auth.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
 

import 'auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MyUser> getCurrentUser()  async{
    try {
      User user =  _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  MyUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    } else {
      return MyUser(userId: user.uid, email: user.email);
    }
  }

  @override
  Future<bool> signOut() async {
    try {
       

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }

  

  @override
  Future<MyUser> createUserWithEmailandPassword(
      String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<MyUser> signInWithEmailandPassword(String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }
}
