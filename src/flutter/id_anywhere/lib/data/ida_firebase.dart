
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConnection {
  final Firestore __databaseReference = new Firestore();
  final FirebaseStorage __cloudStorageReference = new FirebaseStorage();
  
  Future<CollectionReference> getUserInfoReference() async{
    // TODO: REMOVE THIS AND STORE USERNAME AND PASS IN SECURE STORAGE.
    await FirebaseAuth.instance.signInAnonymously();
    return this.__databaseReference.collection("userinf");
  }

  Future<StorageReference> getUserStorageReference() async{
    // TODO: SIGN IN WITH firebase
    await FirebaseAuth.instance.signInAnonymously();
    return this.__cloudStorageReference.ref().child("userinf");
  }
}