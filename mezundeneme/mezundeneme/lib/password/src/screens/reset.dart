import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(title: Text('Şifre Sıfırlama'),),
      body: Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          Padding(
          
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
               keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.mail),
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    border: OutlineInputBorder(),
                                  ),
               onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text('Gönder'),
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                },
                color: Colors.deepOrangeAccent[100],
                textColor: Colors .white,
              ),

            ],
          ),

        ],),
    );
  }
}