import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
 import 'package:mezunlarsistemi/home/welcome/announcements/info.dart';
import 'package:mezunlarsistemi/mesaj/app/duyuru.dart';

class CreateAnnouncements extends StatefulWidget {
  CreateAnnouncements({Key key}) : super(key: key);

  @override
  _CreateAnnouncementsState createState() => _CreateAnnouncementsState();
}

class _CreateAnnouncementsState extends State<CreateAnnouncements> {
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
        title: Text("Duyuru Oluştur"),
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
                  Text("Duyuru Başlığı", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Lütfen duyuru başlığı girin."),
                    ]),
                    keyboardType: TextInputType.name,
                    onSaved: (String title) {
                      announcements.announcementsTitle = title;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Duyuru İçeriği", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: "Lütfen duyuru içeriği girin."),
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
                      child: Text("Duyuru Oluştur",
                          style: TextStyle(fontSize: 20,color: Colors.white)),
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
                                .collection("announcements")
                                .add({
                              'announcementsContent':
                                  announcements.announcementsContent,
                              'announcementsTitle':
                                  announcements.announcementsTitle,
                              'createdAt':
                                  createdAt ?? FieldValue.serverTimestamp(),
                              'email': auth.currentUser.email,
                              'username': nickname
                            });
                            formKey.currentState.reset();
                            Fluttertoast.showToast(
                                msg:
                                    "Duyurunuz başarılı bir şekilde oluşturulmuştur.",
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
