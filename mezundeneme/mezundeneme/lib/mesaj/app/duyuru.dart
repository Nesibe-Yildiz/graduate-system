import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mezunlarsistemi/home/welcome/announcements/announcements.dart';
import 'package:mezunlarsistemi/home/welcome/announcements/myAnnouncements.dart';
import 'package:mezunlarsistemi/home/welcome/haberler/haberlerigoruntule.dart';
import 'package:mezunlarsistemi/home/welcome/haberler/mynews.dart';
import 'package:mezunlarsistemi/home/welcome/olustur.dart';
import 'package:mezunlarsistemi/mesaj/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
 
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var sayfaListe = [
    Announcements(),
    MyAnnouncements(),
    HaberGoruntule(),
    MyNews(),
   ];
  int secilenIndeks = 0;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
      UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Duyurular"),
      ),
      body: sayfaListe[secilenIndeks],
      drawer: Drawer(
        
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(accountName: Text("MEZUN TRAKYA"), currentAccountPicture: Image.network(
            _userModel.user.imageUrl),accountEmail: Text(auth.currentUser.email),
          ),
            
            ListTile(
              title: Text("Duyurularım"),
              onTap: () {
                 
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAnnouncements(),
                    ),
                   
                  ); 
                            },
            ),
            ListTile(
              title: Text("Haberler"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>HaberGoruntule(),
                    ),
                   
                  );  
                 
              },
            ),
            ListTile(
              title: Text("Haberlerim"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyNews(),
                    ),
                   
                  );  
              },
            ),
             
          ],
        ),
        
      ),
      
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(60.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return Olustur();
            }));
          },
          foregroundColor: Colors.white,
          icon: Icon(Icons.add),
          backgroundColor: Colors.deepOrangeAccent[100],
          label: Text("Oluştur"),
        ),
      ),
    );
  }
}
