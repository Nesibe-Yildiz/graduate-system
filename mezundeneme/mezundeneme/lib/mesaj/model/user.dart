import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyUser {
  final String userId;
  String email;
  String username;
  String imageUrl;
  DateTime createdAt;
   

  MyUser({@required this.userId, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'username': username ?? email.substring(0, email.indexOf('@trakya.edu.tr')) + randomSayiUret(),
      'imageUrl': imageUrl ?? 'https://www.trakya.edu.tr/admin/tools/theme/www_v2/images/logo/tr/logo.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
       
    };
  }
  MyUser.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        email = map['email'],
        username = map['username'],
        imageUrl = map['imageUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate();
 
  MyUser.idveResim({@required this.userId, @required this.imageUrl});

  @override
  String toString() {
    return 'User{userId: $userId, email: $email, username: $username, imageUrl: $imageUrl, createdAt: $createdAt }';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}

 