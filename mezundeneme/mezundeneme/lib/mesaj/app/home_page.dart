import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mezunlarsistemi/mesaj/app/duyuru.dart';

import 'package:mezunlarsistemi/mesaj/app/kullanicilar.dart';
import 'package:mezunlarsistemi/mesaj/app/profil.dart';
import 'package:mezunlarsistemi/mesaj/app/tab_items.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
import 'package:mezunlarsistemi/mesaj/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

import 'konusmalarim_page.dart';
import 'my_custom_bottom_navi.dart';

class HomePage extends StatefulWidget {
  final MyUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final _firebaseMessaging = FirebaseMessaging();

  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Duyuru: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
     return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Duyuru: WelcomeScreen(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;
            });
          }
        },
      ),
    );
  }
}
