import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toricar/2SelectMode.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterGmail extends StatefulWidget {
  @override
  _RegisterGmailState createState() => _RegisterGmailState();
}

class _RegisterGmailState extends State<RegisterGmail> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var assetsImage = AssetImage('images/icono.png');
    var imagenLogo = Image(
      image: assetsImage,
      width: 300.0,
      height: 300.0,
      color: Colors.white,
    );
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          fondo,
          Positioned(
              top: 50,
              right: 50,
              left: 50,
              child: Text(
                "¿Estás registrado en el sistema? ingresá tu cuenta.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              )),
          Positioned(
            top: 100,
            left: 50,
            right: 50,
            child: TextField(
              controller: _emailController,
              decoration:
                  InputDecoration(labelText: "Correo", icon: Icon(Icons.email)),
            ),
          ),
          Positioned(
            top: 150,
            left: 50,
            right: 50,
            child: TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "Contraseña", icon: Icon(Icons.vpn_key)),
            ),
          ),
          Positioned(
              top: 220,
              right: 50,
              left: 50,
              child: FlatButton(
                child: Text("Ingresar"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((FirebaseUser user) {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => SelectMode()));
                  }).catchError((e) {
                    showToast();
                    print(e);
                  });
                },
              )),
          Positioned(
              top: 280,
              right: 50,
              left: 50,
              child: FlatButton(
                child: Text("Registrar"),
                color: Colors.orange,
                textColor: Colors.white,
                onPressed: () {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((FirebaseUser user) {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => SelectMode()));
                  }).catchError((e) {
                    showToast();
                    print(e);
                  });
                },
              )),
          Positioned(
              top: 260,
              right: 50,
              left: 50,
              child: Text(
                "o",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              )),
        ],
      ),
    );
  }

  Widget fondo = Container(
      decoration: BoxDecoration(
          color: Colors.blue,
          gradient: LinearGradient(
            colors: [Color(0xff17a7ff), Color(0xff1473ae)],
            begin: Alignment.centerRight,
            end: Alignment(-1.0, -1.0),
          )));

  showToast() {
    Fluttertoast.showToast(
        msg: "Ocurrio un error en el registro",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red[300],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
