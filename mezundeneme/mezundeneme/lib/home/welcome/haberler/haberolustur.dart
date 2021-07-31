import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
 import 'package:mezunlarsistemi/home/welcome/announcements/info.dart';
import 'package:mezunlarsistemi/mesaj/app/duyuru.dart';

class HaberOlustur extends StatefulWidget {
  HaberOlustur({Key key}) : super(key: key);

  @override
  _HaberOlusturState createState() => _HaberOlusturState();
}

class _HaberOlusturState extends State<HaberOlustur> {
  final formKey = GlobalKey<FormState>();
  User user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  Info announcements = Info();
   DateTime createdAt;
  String nickname = "";
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haber Oluştur"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Haber Başlığı", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Lütfen haber başlığı girin."),
                    ]),
                    keyboardType: TextInputType.name,
                    onSaved: (String title) {
                      announcements.announcementsTitle = title;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Haber İçeriği", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Lütfen haber içeriği girin."),
                    ]),
                    keyboardType: TextInputType.name,
                    onSaved: (String content) {
                      print(content);
                      announcements.announcementsContent = content;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child:
                          Text("Haber Oluştur", style: TextStyle(fontSize: 20,color: Colors.white)),
                           style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent[100]),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          formKey.currentState.save();
                          try {
                            await FirebaseFirestore.instance
                                .collection("users")
                                .where("email",
                                    isEqualTo: auth.currentUser.email)
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              querySnapshot.docs.forEach((doc) {
                                nickname = doc["username"];
                              });
                            });
                            await FirebaseFirestore.instance
                                .collection("news")
                                .add({
                              'newsContent': announcements.announcementsContent,
                              'newsTitle': announcements.announcementsTitle,
                              'createdAt':
                                  createdAt ?? FieldValue.serverTimestamp(),
                              'email': auth.currentUser.email,
                              'username': nickname
                            });
                            formKey.currentState.reset();
                            Fluttertoast.showToast(
                                msg:
                                    "Haberiniz başarılı bir şekilde oluşturulmuştur.",
                                gravity: ToastGravity.TOP);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return WelcomeScreen();
                            }));
                          } on Exception {
                            Fluttertoast.showToast(
                                msg: "Bir Hata Oluştu.",
                                gravity: ToastGravity.TOP);
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("İptal", style: TextStyle(fontSize: 20,color: Colors.white)),
                      style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent[100]),
                      onPressed: () async {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return WelcomeScreen();
                        }));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
