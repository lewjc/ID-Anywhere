
import 'package:firebase_database/firebase_database.dart';

class FirebaseConnection {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  
  DatabaseReference getUserInfoReference(){
    return this.databaseReference.child("userinf");
  }
}