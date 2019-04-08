import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toricar/4bMenuRemis.dart';

class ViajesEnColaPage extends StatefulWidget {
  @override
  _ViajesEnColaPageState createState() => _ViajesEnColaPageState();
}

class _ViajesEnColaPageState extends State<ViajesEnColaPage> {
  final db = Firestore.instance;
  String miId = 'su';
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((onValue) {
      setState(() {
        miId = onValue.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Aprobación de Viajes",
          textAlign: TextAlign.center,
          style: TextStyle(),
        ),
      ),
      body: Container(
          child: StreamBuilder(
        stream: db
            .collection('viajes')
            .where('aprobado', isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("error");
          }
          if (snapshot.hasData) {
            return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: snapshot.data.documents
                    .map((doc) => mostrarViajes(doc, miId))
                    .toList());
          }
          return CircularProgressIndicator();
        },
      )),
    );
  }

  Widget mostrarViajes(DocumentSnapshot doc, mid) {
    if (doc.data['remis'] == mid || doc.data['remis'] == "000000") {
      return Center(
        child: Card(
          child: Dismissible(
            key: Key(doc.documentID),
            background: Container(
              color: Colors.red,
              child: Center(
                child: Text("Cancelar Viaje"),
              ),
            ),
            onDismissed: (DismissDirection direction) {
              // doc.reference.delete();
            },
            child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _mostrarNombreCliente(context, doc.data['cliente']),
                    doc.data['aprobado'] == false
                        ? Row(
                            children: <Widget>[
                              Text(
                                "Esperando Aprobacion",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.red),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  child: Text(
                                    "Confirmar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    // eliminarDatos(doc.documentID);
                                    if(doc.data['remis']== "000000"){
                                      Map<String, dynamic> datar = <String, dynamic>{
                                        "remis": miId
                                    };
                                     doc.reference.updateData(datar);
                                    }
                                    Map<String, bool> datar = <String, bool>{
                                      "aprobado": true
                                    };
                                    doc.reference.updateData(datar);
                                    verUbicionRemis();
                                  },
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          )
                        : Text(
                            "Esperando Aprobacion... ",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Destino: ${doc.data['direccionEnd']} ",
                      style: TextStyle(fontSize: 18),
                    ),
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
                trailing: Column(
                  children: <Widget>[],
                )),
          ),
        ),
      );
    } else {
      return Column();
    }
  }

  Widget _mostrarNombreCliente(BuildContext context, idCliente) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('cliente').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        }
        if (snapshot.hasData) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data.documents
                  .map((doc) => traerNombre(doc, idCliente))
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

  void eliminarDatos(String documentID) {
    db
        .collection('viajes')
        .where(('cliente'), isEqualTo: (miId))
        .getDocuments()
        .then((valuer) {
      for (DocumentSnapshot ds in valuer.documents) {
        if (ds.documentID == documentID) {
          print(ds.data);
        } else {
          ds.reference.delete();
        }
      }
    });
  }

  void verUbicionRemis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuRemis(
              tabIndex: 1,
            ),
      ),
    );
  }
}
