import 'package:flutter/material.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
import 'package:mezunlarsistemi/mesaj/repository/user_repository.dart';
 

import '../../locator.dart';
  

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<MyUser> _tumKullanicilar;
  MyUser _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 10;
  bool _hasMore = true;

  bool get hasMoreLoading => _hasMore;

  UserRepository _userRepository = locator<UserRepository>();
  List<MyUser> get kullanicilarListesi => _tumKullanicilar;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

   
  getUserWithPagination(
      MyUser enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {
    if (_tumKullanicilar.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar.last;
      print("en son getirilen username:" + _enSonGetirilenUser.username);
    }

    if (yeniElemanlarGetiriliyor) {
    } else {
      state = AllUserViewState.Busy;
    }

    var list = await _userRepository.getUserwithPagination(
        _enSonGetirilenUser, sayfaBasinaGonderiSayisi);
    var yeniListe = list;

    if (yeniListe.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

 
    _tumKullanicilar.addAll(yeniListe);

    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {
     if (_hasMore) getUserWithPagination(_enSonGetirilenUser, true);
      await Future.delayed(Duration(seconds: 2));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    getUserWithPagination(_enSonGetirilenUser, true);
  }
}
