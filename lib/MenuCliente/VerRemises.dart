import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toricar/4aMenuCliente.dart';
import 'package:toricar/MenuCliente/HistorialPage.dart';
import 'package:toricar/crud.dart';
import 'package:toricar/auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geocoder/geocoder.dart';

class VerRemises extends StatefulWidget {
  const VerRemises(
      {this.auth,
      this.longitudeInicial,
      this.latitudeInicial,
      this.latitudFinal,
      this.longitudFinal,});
  final BaseAuth auth;
  final double longitudeInicial;
  final double latitudeInicial;
  final double latitudFinal;
  final double longitudFinal;
  
  @override
  _VerRemisesState createState() => _VerRemisesState();
}

class _VerRemisesState extends State<VerRemises> {
  crudMedthods crudObj = new crudMedthods();
  CollectionReference _todosRef;
  List<bool> btnCool = List();

  String miId;

  var btnF;

  var calle;
  var entre;

  DateTime _selectedDay;
  int hora;
  int minuto;
  int anio;
  int mes;
  int dia;
  String fechaSeleccionada =
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
  @override
  void initState() {
    super.initState();
    
    buscardestino();

    anio = DateTime.now().year;
    mes = DateTime.now().month;
    dia = DateTime.now().day;
    hora = DateTime.now().hour;
    minuto = DateTime.now().minute;


    btnCool.add(false);
    _todosRef = Firestore.instance.collection('remiseros');
    FirebaseAuth.instance.currentUser().then((onValue) {
      miId = onValue.uid;
    });
  }
void _agregarMarcador()  {
    buscardestino();
 
  }
  buscardestino() async {
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(widget.latitudFinal,widget.longitudFinal));
    var first = addresses.first;
    print("cosas");
   // print(first);
   // print(first.addressLine);
    print(first.adminArea);//Buenos Aires
    //print(first.coordinates);
    
    print(first.countryName);    //Argenitna
  
    print(first.locality);//La Plata
    print(first.postalCode);//b1900  
    print(first.subThoroughfare);  //1378
    print(first.thoroughfare);//calle 5
    calle= first.thoroughfare;
     entre=first.subThoroughfare;
    setState(() {
     calle= first.thoroughfare.toString();
     entre=first.subThoroughfare.toString();
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: _todosRef == null
            ? Text("cargando")
            : Center(
                child: StreamBuilder(
                  stream: _todosRef
                      .where('disponible', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    return snapshot.data == null
                        ? Text("Cargando Datos")
                        : Swiper(
                            itemBuilder: (context, index) {
                              for (var i = 0;
                                  i < snapshot.data.documents.length;
                                  i++) {
                                btnCool.add(false);
                              }
                              btnCool.removeRange(
                                  snapshot.data.documents.length,
                                  btnCool.length);
                              return Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        snapshot.data.documents[index]
                                            .data['nombre'],
                                        style: TextStyle(
                                          color: Colors.blue[800],
                                          fontSize: 32,
                                          fontWeight: FontWeight.w700,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1.0, 0.0),
                                              blurRadius: 5.0,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ConstrainedBox(
                                      constraints:
                                          BoxConstraints.expand(height: 350),
                                      child: InkWell(
                                        onTap: () => {},
                                        child: Card(
                                          clipBehavior: Clip.hardEdge,
                                          elevation: 10,
                                          color: Colors.grey,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: Image.network(
                                            snapshot.data.documents[index]
                                                .data['img'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    snapshot.data.documents[index]
                                                .data['rankingR'] !=
                                            null
                                        ? SmoothStarRating(
                                            starCount: 5,
                                            rating: snapshot
                                                .data
                                                .documents[index]
                                                .data['rankingR'],
                                            size: 40.0,
                                            color: Colors.blue,
                                            borderColor: Colors.blueAccent,
                                          )
                                        : Divider(),
                                    snapshot.data.documents[index]
                                                .data['tiempoEspera'] !=
                                            null
                                        ? ListTile(
                                            subtitle: Text(
                                              "${snapshot.data.documents[index].data['tiempoEspera']} min. Aproximadamente ",
                                              textAlign: TextAlign.center,
                                            ),
                                            title: Text(
                                              "${snapshot.data.documents[index].data['viajesEnCurso']} Viajes en espera",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Divider(),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            snapshot.data.documents[index]
                                                        .data['tarifaK'] ==
                                                    null
                                                ? Divider()
                                                : Icon(Icons.attach_money),
                                            snapshot.data.documents[index]
                                                        .data['tarifaK'] !=
                                                    null
                                                ? Text(
                                                    "${snapshot.data.documents[index].data['tarifaK']}/km ",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )
                                                : Divider(),
                                          ],
                                        ),
                                        btnCool[index] == false
                                            ? FlatButton(
                                                child:
                                                    Text("Pedir que me lleve"),
                                                color: Colors.blue,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  crudObj.agregarViaje(
                                                    {
                                                      'aprobado': false,
                                                      'direccionEnd': "$calle, $entre" ,
                                                      'remis': snapshot
                                                          .data
                                                          .documents[index]
                                                          .documentID,
                                                      'cliente': miId,
                                                      'fecha': "$dia/$mes ",
                                                      'hora': "$hora:$minuto",
                                                      'latEnd':
                                                          widget.latitudFinal,
                                                      'latIn': widget
                                                          .latitudeInicial,
                                                      'longIn': widget
                                                          .longitudeInicial,
                                                      'longEnd':
                                                          widget.longitudFinal
                                                    },
                                                  ).then(
                                                    (results) {
                                                      setState(
                                                        () {
                                                          btnCool[index] = true;
                                                          print(btnCool);
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MenuCliente(
                                                                        tabIndex:
                                                                            2,
                                                                      ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : FlatButton(
                                                child: Text("Esperando Confirmación..."),
                                                color: Colors.red,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          MenuCliente(
                                                            tabIndex: 2,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              )
                                      ],
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
                  },
                ),
              ),
      ),
    );
  }
}
