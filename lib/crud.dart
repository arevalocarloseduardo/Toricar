import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class crudMedthods{
  String miId;

  bool isLoggedIn(){
    if (FirebaseAuth.instance.currentUser() != null){
      FirebaseAuth.instance.currentUser().then((onValue){miId=onValue.uid;});
      return true;
    }else{
      return false;
    }
  }

  Future<void>addData(id,cardData)async{
    if(isLoggedIn()){
      
      Firestore.instance.collection('remiseros').document(id).collection('viajesConfirmar').document(miId).setData(cardData).catchError((e){
        print(e);
      });
    }else{
      print('necesitas registrarte');
    }
  }
  Future<void>agregarViaje(cardData)async{
    if(isLoggedIn()){
      
      Firestore.instance.collection('viajes').document().setData(cardData).catchError((e){
        print(e);
      });
    }else{
      print('necesitas registrarte');
    }
  }    verValor(id)async{
    if(isLoggedIn()){
      
     return await Firestore.instance.collection('remiseros').document(id).collection('viajesConfirmar').document(miId).collection('carname').snapshots();
  }}
  getData()async{
    return await Firestore.instance.collection('viajes').snapshots();
  }
  deleteData(docId){
    Firestore.instance.collection('viajes').document(docId).delete().catchError((e){print(e);
  });
  }
}