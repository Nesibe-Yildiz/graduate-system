import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAnnouncements extends StatefulWidget {
  MyAnnouncements({Key key}) : super(key: key);

  @override
  _MyAnnouncementsState createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Duyurularım')),
      body: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('announcements')
            .where("email", isEqualTo: FirebaseAuth.instance.currentUser.email)
            .snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center();
           if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
              
                children: documents
                    .map(
                      (doc) => Container(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.deepOrangeAccent[100]),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.lightBlue[100],
                          child: Column(
                            
                            children: [
                              
                              ListTile(
                                title: Text(
                                  doc['announcementsTitle'],
                                  style: TextStyle(fontSize: 25),
                                ),
                                subtitle: Text(
                                  doc['announcementsContent'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    doc["username"],
                                    style: TextStyle(fontSize: 20),
                                  ),
                                   
                                ],
                              ),
                            ],
                            
                          ),
                        ),
                      ),
                    )
                    .toList());
          } else if (snapshot.hasError) {
            return Text("It's Error!");
          }
        });
  }
}
