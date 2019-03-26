import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem{
  String id;
  String nombre ='';
  bool disponible = false;
  String ranking ='';
  String tarifa = '';
  String img = '';

  TodoItem(this.nombre,{this.ranking,this.disponible,this.img,this.tarifa});

  TodoItem.from(DocumentSnapshot snapshot):
  id = snapshot.documentID,
  nombre = snapshot['nombre'],
  ranking = snapshot['ranking'],
  disponible = snapshot['disponible'],
  img = snapshot['img'],
  tarifa = snapshot['tarifa'];

  Map<String,dynamic>toJson(){
    return{
      'nombre':nombre,
      'ranking':ranking,
      'disponible':disponible,
      'img':img,
      'tarifa':tarifa,
    };

  }

}