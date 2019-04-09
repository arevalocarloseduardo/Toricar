import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toricar/1SplasScreen.dart';
import 'package:toricar/auth.dart';

class InformacionPage extends StatefulWidget {
  @override
  _InformacionPageState createState() => _InformacionPageState();
}

class _InformacionPageState extends State<InformacionPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void cerrar() async {
    await auth.signOut().then((onValue) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(
                auth: Auth(),
              ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
          FlatButton(
            child: Text("Cerrar seccion"),
            onPressed: cerrar,
            color: Colors.orange,
          ),
          Text(
              "aca se mostrar la informacion del usuario. estrellas, rankin etc"),
        ],
      )),
    );
  }
}
