import 'dart:io';

import 'package:mezunlarsistemi/locator.dart';
import 'package:mezunlarsistemi/mesaj/model/konusma.dart';
import 'package:mezunlarsistemi/mesaj/model/mesaj.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
import 'package:mezunlarsistemi/mesaj/services/auth_base.dart';
import 'package:mezunlarsistemi/mesaj/services/firebase_auth_service.dart';
import 'package:mezunlarsistemi/mesaj/services/firebase_storage_service.dart';
import 'package:mezunlarsistemi/mesaj/services/firestore_db_service.dart';

import 'package:timeago/timeago.dart' as timeago;

 
class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
   FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
 
   List<MyUser> tumKullaniciListesi = [];
  Map<String, String> kullaniciToken = Map<String, String>();

  @override
  Future<MyUser> getCurrentUser() async {
     
      MyUser _user = await _firebaseAuthService.getCurrentUser();
      if (_user != null)
        return await _firestoreDBService.readUser(_user.userId);
      else
        return null;
    
  }

  @override
  Future<bool> signOut() async {
     
      return await _firebaseAuthService.signOut();
    
  }

   

  
  @override
  Future<MyUser> createUserWithEmailandPassword(String email, String sifre) async {
     
      MyUser _user = await _firebaseAuthService.createUserWithEmailandPassword(email, sifre);
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userId);
      } else
        return null;
    
  }

  @override
  Future<MyUser> signInWithEmailandPassword(String email, String sifre) async {
     
      MyUser _user = await _firebaseAuthService.signInWithEmailandPassword(email, sifre);

      return await _firestoreDBService.readUser(_user.userId);
    
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    
  }

  Future<String> uploadFile(String userID, String fileType, File profilFoto) async {
     
      var profilFotoURL = await _firebaseStorageService.uploadFile(userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoURL);
      return profilFotoURL;
    
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID) {
     
      return _firestoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, MyUser currentUser) async {
    
      var dbYazmaIslemi = await _firestoreDBService.saveMessage(kaydedilecekMesaj);

      if (dbYazmaIslemi) {
        var token = "";
        if (kullaniciToken.containsKey(kaydedilecekMesaj.kime)) {
          token = kullaniciToken[kaydedilecekMesaj.kime];
          //print("Localden geldi:" + token);
        } else {
         // token = await _firestoreDBService.tokenGetir(kaydedilecekMesaj.kime);
          if (token != null) kullaniciToken[kaydedilecekMesaj.kime] = token;
          //print("Veri tabanından geldi:" + token);
        }

        //if (token != null) await _bildirimGondermeServis.bildirimGonder(kaydedilecekMesaj, currentUser, token);

        return true;
      } else
        return false;
    
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
     
      DateTime _zaman = await _firestoreDBService.saatiGoster(userID);

      var konusmaListesi = await _firestoreDBService.getAllConversations(userID);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici = listedeUserBul(oankiKonusma.kimle_konusuyor);

        if (userListesindekiKullanici != null) {
          //print("VERILER LOCAL CACHEDEN OKUNDU");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.username;
          oankiKonusma.konusulanUserProfilURL = userListesindekiKullanici.imageUrl;
        } else {
          //print("VERILER VERITABANINDAN OKUNDU");
          /*print(
              "aranılan user daha önceden veritabanından getirilmemiş, o yüzden veritabanından bu degeri okumalıyız");*/
          var _veritabanindanOkunanUser = await _firestoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.username;
          oankiKonusma.konusulanUserProfilURL = _veritabanindanOkunanUser.imageUrl;
        }

        timeagoHesapla(oankiKonusma, _zaman);
      }

      return konusmaListesi;
    
  }

  MyUser listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userId == userID) {
        return tumKullaniciListesi[i];
      }
    }

    return null;
  }

  void timeagoHesapla(Konusma oankiKonusma, DateTime zaman) {
    oankiKonusma.sonOkunmaZamani = zaman;

    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.aradakiFark = timeago.format(zaman.subtract(_duration), locale: "tr");
  }

  Future<List<MyUser>> getUserwithPagination(MyUser enSonGetirilenUser, int getirilecekElemanSayisi) async {
    
      List<MyUser> _userList = await _firestoreDBService.getUserwithPagination(enSonGetirilenUser, getirilecekElemanSayisi);
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    
  }

  Future<List<Mesaj>> getMessageWithPagination(String currentUserID, String sohbetEdilenUserID, Mesaj enSonGetirilenMesaj, int getirilecekElemanSayisi) async {
     
      return await _firestoreDBService.getMessagewithPagination(currentUserID, sohbetEdilenUserID, enSonGetirilenMesaj, getirilecekElemanSayisi);
    
  }
}
