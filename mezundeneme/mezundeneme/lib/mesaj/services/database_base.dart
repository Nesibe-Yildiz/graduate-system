import 'package:mezunlarsistemi/mesaj/model/konusma.dart';
import 'package:mezunlarsistemi/mesaj/model/mesaj.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
 
 
abstract class DBBase {
  Future<bool> saveUser(MyUser user);
  Future<MyUser> readUser(String userID);
  Future<bool> updateUserName(String userID, String yeniUserName);
  Future<bool> updateProfilFoto(String userID, String profilFotoURL);
  Future<List<MyUser>> getUserwithPagination(MyUser enSonGetirilenUser, int getirilecekElemanSayisi);
  Future<List<Konusma>> getAllConversations(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  Future<DateTime> saatiGoster(String userID);
}
