import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? id;
  String? displayName;
  String? photoURL;
  String? email;
  String? uid;

  UserModel({this.id, this.displayName, this.photoURL, this.email, this.uid});

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      displayName: doc['displayName'],
      photoURL: doc['photoURL'],
      email: doc['email'],
      uid: doc['uid'],
    );
  }

  void setFromFirestore(DocumentSnapshot doc) {
    id = doc.id;
    displayName = doc['displayName'];
    photoURL = doc['phoroURL'];
    email = doc['email'];
    uid = doc['uid'];
    notifyListeners();
  }
}