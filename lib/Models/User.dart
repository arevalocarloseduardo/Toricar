import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  String name;
  DocumentReference reference;

  User({this.name});

  User.fromMap(Map<String,dynamic>map,{this.reference}){
    name = map['nombre'];
  }
  User.fromSnapshot(DocumentSnapshot snapshot):this.fromMap(snapshot.data,reference:snapshot.reference);
}