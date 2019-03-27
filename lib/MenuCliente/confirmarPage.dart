import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toricar/Models/TodoItem.dart';
import 'package:toricar/crud.dart';
import 'package:toricar/auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ConfirmarPage extends StatefulWidget {
  const ConfirmarPage(
      {this.auth,
      this.longitudeInicial,
      this.latitudeInicial,
      this.latitudFinal,
      this.longitudFinal});
  final BaseAuth auth;
  final double longitudeInicial;
  final double latitudeInicial;
  final double latitudFinal;
  final double longitudFinal;
  @override
  _ConfirmarPageState createState() => _ConfirmarPageState();
}

class _ConfirmarPageState extends State<ConfirmarPage> {
  QuerySnapshot cars;

  crudMedthods crudObj = new crudMedthods();
  CollectionReference _todosRef;
  @override
  void initState() { crudObj.getData().then((results){
      setState(() {
       cars = results;
      });
    });
    super.initState();
    _todosRef=Firestore.instance.collection('remiseros');
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: StreamBuilder(stream:Firestore.instance.collection('remiseros').where('nombre',isEqualTo:'Carlos').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Swiper(
              itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 350),
                      child: InkWell(
                        onTap: () => {Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConfirmarPage(
                  auth: Auth(),
                  latitudeInicial: widget.latitudeInicial,
                  longitudeInicial: widget.longitudeInicial,
                  latitudFinal:widget.latitudFinal,
                  longitudFinal:widget.longitudFinal,
                )))},
                        child:Card(
                        clipBehavior: Clip.hardEdge,
                        elevation: 10,
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Image.network(
                          snapshot.data.documents[index].data['img'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ) 
                  ),
                    Center(
                      child: Text(snapshot.data.documents[index].data['nombre'],
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(1.0, 0.0),
                                blurRadius: 15.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ]),
                      ),
                    ),
                    
                  ],
                ),
              );
        },
        control: SwiperControl(),
        loop: false,
        itemCount: snapshot.data.documents.length,
        viewportFraction: 0.8,
        scale: 0.9,
      );
            }
          ),
        ),
      ),
    );
  }
}
