 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:mezunlarsistemi/mesaj/app/hata_exception.dart';
import 'package:mezunlarsistemi/mesaj/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:mezunlarsistemi/mesaj/common_widget/social_log_in_button.dart';
import 'package:mezunlarsistemi/mesaj/model/user.dart';
import 'package:mezunlarsistemi/mesaj/viewmodel/user_model.dart';
import 'package:mezunlarsistemi/password/src/screens/reset.dart';
import 'package:mezunlarsistemi/password/src/screens/verify.dart';
import 'package:provider/provider.dart';
 

enum FormType { Register, LogIn }
PlatformException myHata;

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _butonText, _linkText;
  var _formType = FormType.LogIn;

  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState.save();
    debugPrint("email :" + _email + " şifre:" + _sifre);

    final _userModel = Provider.of<UserModel>(context, listen: false);
     @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (myHata != null)
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Hatalar.goster(myHata.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
    });
  }

    if (_formType == FormType.LogIn) {
      try {
        MyUser _girisYapanUser =
            await _userModel.signInWithEmailandPassword(_email, _sifre);
        if (_girisYapanUser != null)
          print("Oturum açan user id:" + _girisYapanUser.userId.toString());
      } on FirebaseAuthException catch (e) {
        print("hata ${e.code}");
        PlatformDuyarliAlertDialog(
          baslik: "Oturum Açma HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    } else {
      try {
        MyUser _olusturulanUser =
            await _userModel.createUserWithEmailandPassword(_email, _sifre);
        if (_olusturulanUser != null)
          print("Oturum açan user id:" + _olusturulanUser.userId.toString());
      } on FirebaseAuthException catch (e) {
        print("hata ${e.code}");
        PlatformDuyarliAlertDialog(
          baslik: "Kullanıcı Oluşturma HATA",
          icerik: Hatalar.goster(e.code),
          anaButonYazisi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.LogIn ? "Giriş Yap " : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız Yok Mu? Kayıt Olun"
        : "Hesabınız Var Mı? Giriş Yapın";
    final _userModel = Provider.of<UserModel>(context);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }
    

    return Scaffold(
      
      body: Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "MEZUN TRAKYA",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
              ),
              SizedBox(
                height: 8,
              ),
              _userModel.state == ViewState.Idle
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                   keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    errorText:
                                        _userModel.emailHataMesaji != null
                                            ? _userModel.emailHataMesaji
                                            : null,
                                    prefixIcon: Icon(Icons.mail),
                                    hintText: 'mezuntrakya@trakya.edu.tr',
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (String girilenEmail) {
                                    _email = girilenEmail;
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                TextFormField(
                                  
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    errorText:
                                        _userModel.sifreHataMesaji != null
                                            ? _userModel.sifreHataMesaji
                                            : null,
                                    prefixIcon: Icon(Icons.lock),
                                    hintText: 'Sifre',
                                    labelText: 'Sifre',
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (String girilenSifre) {
                                    _sifre = girilenSifre;
                                  },
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                SocialLoginButton(
                                  butonText: _butonText,
                                  butonColor:Colors.deepOrangeAccent[100],
                                  radius: 10,
                                  onPressed: () => _formSubmit(),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                  onPressed: () => _degistir(),
                                  child: Text(_linkText),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text('Şifrenizi Mi Unuttunuz?'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResetScreen()),
                ),
              )
            ],
          )
        ,
                              ],
                            )),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ]),
      ),
    );
  }
}
 