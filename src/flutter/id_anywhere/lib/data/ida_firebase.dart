
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConnection {
  final Firestore __databaseReference = new Firestore();
  
  Future<CollectionReference> getUserInfoReference() async{
    await FirebaseAuth.instance.signInAnonymously();
    return this.__databaseReference.collection("userinf");
  }
}