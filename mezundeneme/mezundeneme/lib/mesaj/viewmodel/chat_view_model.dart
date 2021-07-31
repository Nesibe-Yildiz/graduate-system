
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mezunlarsistemi/mesaj/model/mesaj.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
import 'package:mezunlarsistemi/mesaj/repository/user_repository.dart';

import '../../locator.dart';
 
enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  static final sayfaBasinaGonderiSayisi = 10;
  UserRepository _userRepository = locator<UserRepository>();
  final MyUser currentUser;
  final MyUser sohbetEdilenUser;
  Mesaj _enSonGetirilenMesaj;
  Mesaj _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _yeniMesajDinleListener = false;

  bool get hasMoreLoading => _hasMore;

  StreamSubscription _streamSubscription;

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(false);
  }

  List<Mesaj> get mesajlarListesi => _tumMesajlar;

  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

   @override
  dispose() {
    print("Chatviewmodel dispose edildi");
    _streamSubscription.cancel();
    super.dispose();
  }
  

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, MyUser currentUser) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj, currentUser);
  }

  void getMessageWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_tumMesajlar.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
    }

    if (!yeniMesajlarGetiriliyor) state = ChatViewState.Busy;

    var getirilenMesajlar =
        await _userRepository.getMessageWithPagination(currentUser.userId, sohbetEdilenUser.userId, _enSonGetirilenMesaj, sayfaBasinaGonderiSayisi);

    if (getirilenMesajlar.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    } 

    _tumMesajlar.addAll(getirilenMesajlar);
    if (_tumMesajlar.length > 0) {
      _listeyeEklenenIlkMesaj = _tumMesajlar.first;
     }

    state = ChatViewState.Loaded;

    if (_yeniMesajDinleListener == false) {
      _yeniMesajDinleListener = true;
       yeniMesajListenerAta();
    }
  }

  Future<void> dahaFazlaMesajGetir() async {
     if (_hasMore) getMessageWithPagination(true);
  
    await Future.delayed(Duration(seconds: 2));
  }

  void yeniMesajListenerAta() {
     _streamSubscription = _userRepository.getMessages(currentUser.userId, sohbetEdilenUser.userId).listen((anlikData) {
      if (anlikData.isNotEmpty) {
 
        if (anlikData[0].date != null) {
          if (_listeyeEklenenIlkMesaj == null) {
            _tumMesajlar.insert(0, anlikData[0]);
          } else if (_listeyeEklenenIlkMesaj.date.millisecondsSinceEpoch != anlikData[0].date.millisecondsSinceEpoch) _tumMesajlar.insert(0, anlikData[0]);
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}