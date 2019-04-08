import 'package:flutter/material.dart';
import 'package:toricar/1SplasScreen.dart';
import 'package:toricar/auth.dart';

//Toricar es una Aplicacion creada en flutter inspirada en Uber

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //Este widget es la raiz del programa
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Toricar',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(auth: Auth()),     
    );
  }
}

