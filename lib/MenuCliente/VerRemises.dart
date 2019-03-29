import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toricar/MenuCliente/confirmarPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toricar/crud.dart';
import 'package:toricar/auth.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class VerRemises extends StatefulWidget {
  const VerRemises(
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
  _VerRemisesState createState() => _VerRemisesState();
}

class _VerRemisesState extends State<VerRemises> {
  QuerySnapshot cars;

  crudMedthods crudObj = new crudMedthods();
  CollectionReference _todosRef;
 List <bool>btnCool=List();

  String miId;

  var bt;

  var btnF;
  @override
  void initState() {
    crudObj.getData().then((results) {
      setState(() {
        cars = results;
      });
    });
    super.initState();
    btnCool.add(false);
    _todosRef = Firestore.instance.collection('remiseros');
    FirebaseAuth.instance.currentUser().then((onValue) {
      miId = onValue.uid;
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
                  stream: Firestore.instance
                      .collection('remiseros')
                      .where('disponible', isEqualTo: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                       
                        
                             
                    return Swiper(                      
                      itemBuilder: (context, index) {
                        
                        for (var i = 0; i < snapshot.data.documents.length; i++) {                          
                            btnCool.add(false);                       
                        }
                        btnCool.removeRange(snapshot.data.documents.length, btnCool.length);
                        
                                                                
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Center(
                                child: Text(
                                  snapshot.data.documents[index].data['nombre'],
                                  style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 0.0),
                                        blurRadius: 5.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.expand(height: 350),
                                child: InkWell(
                                  onTap: () => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ConfirmarPage(
                                                  auth: Auth(),
                                                  latitudeInicial:
                                                      widget.latitudeInicial,
                                                  longitudeInicial:
                                                      widget.longitudeInicial,
                                                  latitudFinal:
                                                      widget.latitudFinal,
                                                  longitudFinal:
                                                      widget.longitudFinal,
                                                ),
                                          ),
                                        ),
                                      },
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    elevation: 10,
                                    color: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Image.network(
                                      snapshot
                                          .data.documents[index].data['img'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SmoothStarRating(
                                starCount: 5,
                                rating: snapshot
                                    .data.documents[index].data['rankingR'],
                                size: 40.0,
                                color: Colors.blue,
                                borderColor: Colors.blueAccent,
                              ),
                              ListTile(
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
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.attach_money),
                                      Text(
                                        "${snapshot.data.documents[index].data['tiempoEspera']}/km ",
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                 btnCool[index] == false? FlatButton(
                                          child: Text("Pedir que me lleve"),
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          onPressed: () {
                                             /*crudObj.agregarViaje(
                                                    {'aprobado': false,'remis':
                                                    snapshot.data.documents[index]
                                                        .documentID,
                                                        'cliente':miId,
                                                        'fecha':"07/01",
                                                        'hora':"12:51",
                                                        'latEnd':widget.latitudFinal,
                                                        'latIn':widget.latitudeInicial,
                                                        'longIn':widget.longitudeInicial,
                                                        'longEnd':widget.longitudFinal}).then((results) {*/
                                                  setState(() {
                                                    btnCool[index]=true;
                                                    print(btnCool);

                                                 /* });*/
                                                });}):FlatButton(
                                          child: Text("Esperando Confirmación..."),
                                          color: Colors.red,
                                          textColor: Colors.white,
                                          onPressed: () {
                                             /*crudObj.agregarViaje(
                                                    {'aprobado': false,'remis':
                                                    snapshot.data.documents[index]
                                                        .documentID,
                                                        'cliente':miId,
                                                        'fecha':"07/01",
                                                        'hora':"12:51",
                                                        'latEnd':widget.latitudFinal,
                                                        'latIn':widget.latitudeInicial,
                                                        'longIn':widget.longitudeInicial,
                                                        'longEnd':widget.longitudFinal}).then((results) {*/
                                                  setState(() {
                                                    btnCool[index]=false;
                                                    print(btnCool);
                                                    
                                                 /* });*/
                                                });})/*StreamBuilder(
                                      stream: Firestore.instance
                                          .collection('remiseros')
                                          .document(snapshot
                                              .data.documents[index].documentID).collection('viajesConfirmar').document(miId)
                                          .snapshots(),
                                      builder: (context, ssnapshot) {
                                        if (ssnapshot.connectionState==null){
                                          return Text("data");
                                        }
                                        print('Snapshot dale guasho: $ssnapshot');
                                        return  FlatButton(
                                          child: Text(
                                              "Pedir que ssme lleve ${ssnapshot.data['carname']}"),
                                          onPressed: () {
                                             crudObj.getData().then((results) {
                                                  setState(() {
                                                    cars = results;
                                                    tengoViaje = cars.documents[index].data['viajesConfirmar'].data[miId].data['carname'];
                                                  });
                                                });
                                                
                                               
                                                crudObj.addData(
                                                    snapshot.data.documents[index]
                                                        .documentID,
                                                    {'carname': false});
                                          },
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                        );
                                      })*/
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
//tengo que ver como escribir
