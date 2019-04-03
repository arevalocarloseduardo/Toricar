import 'package:cloud_firestore/cloud_firestore.dart';

class TodoItem{
  String id;
  String nombre ='';
  bool aprobado = false;
  String fecha ='';
  String cliente = '';
  String remis = '';
  String hora = '';
  double latEnd = 0.00;
  double longEnd = 0.00;
  double latIn = 0.00;
  double longIn = 0.00;

  TodoItem(this.nombre,{this.fecha,this.aprobado,this.remis,this.cliente,this.hora,this.latEnd,this.latIn,this.longEnd,this.longIn});

  TodoItem.from(DocumentSnapshot snapshot):
  id = snapshot.documentID,
  nombre = snapshot['nombre'],
  fecha = snapshot['fecha'],
  aprobado = snapshot['aprobado'],
  remis = snapshot['remis'],
  latEnd = snapshot['latEnd'],
  latIn = snapshot['latIn'],
  longEnd = snapshot['longEnd'],
  longIn = snapshot['longIn'],
  cliente = snapshot['cliente'];
  

  Map<String,dynamic>toJson(){
    return{
      'nombre':nombre,
      'fecha':fecha,
      'aprobado':aprobado,
      'remis':remis,
      'latEnd':latEnd,
      'latIn':latIn,
      'longEnd':longEnd,
      'longIn':longIn,
      'cliente':cliente,
    };

  }

}