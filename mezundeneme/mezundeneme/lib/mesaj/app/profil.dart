import 'dart:io';

import 'package:flutter/material.dart';
   import 'package:image_picker/image_picker.dart';
import 'package:mezunlarsistemi/mesaj/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:mezunlarsistemi/mesaj/common_widget/social_log_in_button.dart';
import 'package:mezunlarsistemi/mesaj/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilFoto;

   
 final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
     
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  void _kameradanFotoCek(ImageSource source) async {
    // ignore: deprecated_member_use
    var _yeniResim = await _picker.getImage(source: source);

    setState(() {
      _profilFoto = File(_yeniResim.path);
      Navigator.of(context).pop();
    });
  }

  void _galeridenResimSec(ImageSource source) async {
    // ignore: deprecated_member_use
    var _yeniResim = await _picker.getImage(source: source);

    setState(() {
      _profilFoto = File(_yeniResim.path);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.user.username;
    //print("Profil sayfasındaki user degerleri :" + _userModel.user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _cikisIcinOnayIste(context),
            child: Text(
              "Çıkış",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 160,
                            child: Column(
                              children: <Widget>[
                               ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text("Kameradan Çek"),
                                  onTap: () {
                                    _kameradanFotoCek(ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.image),
                                  title: Text("Galeriden Seç"),
                                  onTap: () {
                                    _galeridenResimSec(ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: _profilFoto == null ? NetworkImage(_userModel.user.imageUrl) : FileImage(_profilFoto),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: _userModel.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Email ",
                    hintText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _controllerUserName,
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı",
                    hintText: 'Kullanıcı Adı',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SocialLoginButton(
                  butonColor:Colors.deepOrangeAccent[100],
                  butonText: "Değişiklikleri Kaydet",
                  onPressed: () {
                    _userNameGuncelle(context);
                    _profilFotoGuncelle(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak istediğinizden emin misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.username != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(_userModel.user.userId, _controllerUserName.text);

      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Username değiştirildi",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user.username;
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "Username zaten kullanımda, farklı bir username deneyiniz",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      var url = await _userModel.uploadFile(_userModel.user.userId, "profil_foto", _profilFoto);
      //print("gelen url :" + url);

      if (url != null) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Profil fotoğrafınız güncellendi",
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }
}
