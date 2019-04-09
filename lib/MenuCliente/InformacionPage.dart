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
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.max,mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text("Cerrar sesion"),
            onPressed: cerrar,
            color: Colors.orange,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                "Proximamente...acá se mostrará toda la informacion del usuario. rankin etc"),
          ),
        ],
      )),
    );
  }
}
