import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toricar/2SelectMode.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

//Este Screen es un splash con 3 segundos de duración
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //inicializamos un timer que al finalizar navegue a la siguiente screen
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SelectMode()),
            ));
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    imagenLogo,
                  ],
                )),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Bienvenido..",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          )
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
      ),
    ),
  );
}
