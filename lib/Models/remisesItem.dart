import 'package:cloud_firestore/cloud_firestore.dart';

class RemisItem{
  String id;
  String nombre ='';
  bool disponible = false;
  String ranking ='';
  String tarifa = '';
  String img = '';
  String tiempoEspera='';

  RemisItem(this.nombre,{this.ranking,this.disponible,this.img,this.tarifa,this.tiempoEspera});

  RemisItem.from(DocumentSnapshot snapshot):
  id = snapshot.documentID,
  nombre = snapshot['nombre'],
  ranking = snapshot['ranking'],
  disponible = snapshot['disponible'],
  img = snapshot['img'],
  tiempoEspera = snapshot['tiempoEspera'],
  tarifa = snapshot['tarifa'];

  Map<String,dynamic>toJson(){
    return{
      'nombre':nombre,
      'ranking':ranking,
      'disponible':disponible,
      'img':img,
      'tiempoEspera':tiempoEspera,
      'tarifa':tarifa,
    };

  }

}