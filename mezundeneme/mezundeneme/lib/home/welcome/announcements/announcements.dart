import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Announcements extends StatefulWidget {
  Announcements({Key key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('announcements').snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center();
          if (snapshot.data.docs.length!=0) 
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
