import 'package:mezunlarsistemi/mesaj/model/user.dart';
  
abstract class AuthBase {
  Future<MyUser> getCurrentUser();
   
  Future<bool> signOut();
   
  Future<MyUser> signInWithEmailandPassword(String email, String sifre);
  Future<MyUser> createUserWithEmailandPassword(String email, String sifre);
}
