import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudMedthods{
  bool isLoggedIn(){
    if (FirebaseAuth.instance.currentUser() != null){
      return true;
    }else{
      return false;
    }
  }

  Future<void>addData(cardData)async{
    if(isLoggedIn()){
      Firestore.instance.collection('remis').add(cardData).catchError((e){
        print(e);
      });
    }else{
      print('necesitas registrarte');
    }
  }
  getData()async{
    return await Firestore.instance.collection('remiseros').snapshots();
  }
}