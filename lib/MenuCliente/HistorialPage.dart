import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final db = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ListView(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: db.collection('viajes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data.documents
                          .map((doc) => mostrarViajes(doc))
                          .toList());
                } else {
                  return CircularProgressIndicator();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Card mostrarViajes(DocumentSnapshot doc) {
    var idRemisero = doc.data['remis'];
    double lat =doc.data['latEnd'];
    double long = doc.data['longEnd'];    
    
    
    return Card(
      child: Dismissible(
        key: Key(doc.documentID),
        background: Container(
          color: Colors.red,
          child: Center(
            child: Text("Cancelar Viaje"),
          ),
        ),
        onDismissed: (DismissDirection direction) {
          doc.reference.delete();
        },
        child: ListTile(
          title: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _mostrarNombreRemis(context, idRemisero),
              doc.data['aprobado']==false?
              Text("Esperando Aprobacion... ",style: TextStyle(fontSize: 18,color: Colors.red),):
              Text("Aprobado",style: TextStyle(fontSize: 18,color: Colors.green),),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Destino: ${doc.data['direccionEnd']} ",style: TextStyle(fontSize: 18),),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Hora: ${doc.data['hora']} ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "${doc.data['fecha']} ",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(children: <Widget>[
            _mostrarFoto(context, idRemisero)
            
          ],)
                  ),
                ),
              );
            }
            //_mostrarNombreRemis(context, idRemisero),Text(doc.data['cliente'])
            
            Widget _mostrarNombreRemis(BuildContext context, idRemisero) {
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('remiseros').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("error");
                  }
                  if (snapshot.hasData) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data.documents
                            .map((doc) => traerNombre(doc, idRemisero))
                            .toList());
                  }
                  return CircularProgressIndicator();
                },
              );
            }
          
            Column traerNombre(DocumentSnapshot docs, idRemisero) {
              if (docs.documentID == idRemisero) {
                return Column(
                  children: <Widget>[
                    Text(
                      "${docs.data['nombre']}",
                      style: TextStyle(fontSize: 22),
                    ),
                  ],
                );
              } else {
                return Column();
              }
            }

            Widget traerfoto(DocumentSnapshot docs, idRemisero) {
              if (docs.documentID == idRemisero) {
                return ClipOval(
              child: Image.network(
            "${docs.data['img']}",
            fit: BoxFit.cover,
            width: 52.0,
            height: 52.0,
          ));
              } else {
                return ClipOval(
              child: Image.network(
            "",
            fit: BoxFit.cover,
            width: 52.0,
            height: 52.0,
          ));
              }
            }


          
            _mostrarFoto(BuildContext context, idRemisero) {
              return StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('remiseros').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("error");
                  }
                  if (snapshot.hasData) {
                    return Stack(
                        children: snapshot.data.documents
                            .map((doc) => traerfoto(doc, idRemisero))
                            .toList());
                  }
                  return CircularProgressIndicator();
                },
              );

              
            }

 
}
