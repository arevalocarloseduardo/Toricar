import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InfoRemisPage extends StatefulWidget {
  @override
  _InfoRemisPageState createState() => _InfoRemisPageState();
}

class _InfoRemisPageState extends State<InfoRemisPage> {
  CollectionReference _todosRef;

  bool _value = false;
  var _miId;

  @override
  void initState() {
    super.initState();
    _todosRef = Firestore.instance.collection('remiseros');
    FirebaseAuth.instance.currentUser().then((onValue) {
      _miId = onValue.uid;
    });
  }

  void _onChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: _todosRef.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("error");
            }
            if (snapshot.hasData) {
              return Column(mainAxisSize: MainAxisSize.max,crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
        
                  children: snapshot.data.documents
                      .map((doc) => dibujarContenido(doc, _miId))
                      .toList());
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget dibujarContenido(DocumentSnapshot doc, miId) {
    if (doc.documentID == miId) {
      return Center(
        child: SwitchListTile(
          title: doc.data['disponible']==true?Text("Disponible"):Text("No Disponible"),
          secondary: doc.data['disponible']==true?Icon(Icons.work,color: Colors.blue,):Icon(Icons.work,color: Colors.red,),
          activeColor: Colors.green,
          value: doc.data['disponible'],
          onChanged: (bool value) {            
            Map<String, bool> datar = <String, bool>{"disponible": value};
            doc.reference.updateData(datar);
          },
        ),
      );
    }else {
      return Center();
    }
  }
}
