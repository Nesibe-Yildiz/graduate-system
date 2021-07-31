import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
 import 'package:mezunlarsistemi/home/welcome/announcements/createAnnouncements.dart';
import 'package:mezunlarsistemi/home/welcome/announcements/info.dart';
import 'package:mezunlarsistemi/home/welcome/haberler/haberlerigoruntule.dart';
import 'package:mezunlarsistemi/home/welcome/haberler/haberolustur.dart';
  import 'package:mezunlarsistemi/mesaj/app/duyuru.dart';

class Olustur extends StatefulWidget {
  Olustur({Key key}) : super(key: key);

  @override
  _OlusturState createState() => _OlusturState();
}

class _OlusturState extends State<Olustur> {
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
        title: Text("Oluştur"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("Duyuru Oluştur",
                          style: TextStyle(fontSize: 20,color: Colors.white)),
                           style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent[100]),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return CreateAnnouncements();
                        }));
                      },
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child:
                          Text("Haber Oluştur", style: TextStyle(fontSize: 20,color: Colors.white)),
                           style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent[100]),
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HaberOlustur();
                        }));
                      },
                    ),
                  ),
                   
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      
                      child:Text("İptal", style: TextStyle(fontSize: 20,color: Colors.white)),
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
