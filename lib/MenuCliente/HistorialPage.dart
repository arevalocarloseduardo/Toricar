import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toricar/Models/TodoItem.dart';
import 'package:toricar/Models/User.dart';
import 'package:toricar/Models/remisesItem.dart';
import 'package:toricar/crud.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  CollectionReference _todosRef;
  CollectionReference _remisRef;
  FirebaseUser _user;

  String id;
  final db = Firestore.instance;
  String name;

  DocumentSnapshot docu;
  @override
  void initState() {
    super.initState();
    _setUpTodoPage();
  }

  getUsers() {
    Firestore.instance.collection('remiseros').snapshots();
  }

  addUser() {}

  void _setUpTodoPage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _user = user;
      _todosRef = Firestore.instance.collection('viajes');
      _remisRef = Firestore.instance.collection('remiseros');
    });
  }

  void _cargarDatos() async {}

  Widget buildBodys() {
    if (_todosRef == null) {
      return CircularProgressIndicator();
    } else {
      return StreamBuilder(
          stream: _todosRef.where('aprobado', isEqualTo: false).snapshots(),
          builder: _buildTodoList);
    }
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('remiseros').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        }
        if (snapshot.hasData) {
          return buildList(context, snapshot.data.documents);
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) {
        buildListem(context, data);
      }).toList(),
    );
  }

  Widget buildListem(BuildContext context, DocumentSnapshot data) {
    final record = User.fromSnapshot(data);
    return Column(
      children: <Widget>[
        Center(child: Text(record.name)),
      ],
    );
  }

  Widget _buildTodoList(
      BuildContext buildContext, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    } else {
      if (snapshot.data.documents.length == 0) {
        return Text("error");
      } else {
        return ListView(
          children: snapshot.data.documents.map(
            (DocumentSnapshot document) {
              TodoItem item = TodoItem.from(document);
              return Dismissible(
                key: Key(item.id),
                background: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text("Cancelar Viaje"),
                  ),
                ),
                onDismissed: (DismissDirection direction) {
                  document.reference.delete();
                },
                child: Card(
                  child: ListTile(
                    title: Text(item.id),
                    subtitle: Text(""),
                  ),
                ),
              );
            },
          ).toList(),
        );
      }
    }
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
                return Text("data");
              }
            },
          )
        ],
      )),
    );
  }
  Card mostrarViajes(DocumentSnapshot doc) { 
    var idRemisero = doc.data['remis'];   
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(doc.data['cliente']),
            _mostrarNombreRemis(context,idRemisero)
          ],
        ),
      ),
    );
  }
  
  Widget _mostrarNombreRemis(BuildContext context, idRemisero) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('remiseros').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("error");
        }
        if (snapshot.hasData) {
          return Column(
                    children: snapshot.data.documents
                        .map((doc) => traerNombre(doc,idRemisero))
                        .toList());
        }
        return CircularProgressIndicator();
      },
    );
  }
 Column traerNombre(DocumentSnapshot docs, idRemisero) {
   if (docs.documentID==idRemisero){
   return Column(
     children: <Widget>[
       Text(docs.data['nombre']),
     ],
   );}
   else{
     return Column();
   }
   
 }
  

 
}
