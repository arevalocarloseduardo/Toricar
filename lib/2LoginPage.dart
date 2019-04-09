import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toricar/1SplasScreen.dart';
import 'package:toricar/3bLoginRemis.dart';
import 'package:toricar/4aMenuCliente.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/crud.dart';

class VerificarCampoEmail {
  static String validar(String valor) {
    return valor.isEmpty ? 'El campo no puede estar vacio' : null;
  }
}

class VerificarCampoPass {
  static String validar(String valor) {
    return valor.isEmpty ? 'El campo no puede estar vacio' : null;
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  crudMedthods crudObj = new crudMedthods();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _nombre;
  String _tel;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validarEnviar() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          final String userId =
              await widget.auth.signInWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (context) => SplashScreen(auth: Auth(),)));
        } else {
          final String userId = await widget.auth
              .createUserWithEmailAndPassword(_email, _password)
              .then((onValue) {
            crudObj.agregarCliente(onValue, {
              'nombre': _nombre,
              'correo': _email,
              'tel': _tel,
            }).then((results) {
               Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => SplashScreen(auth: Auth(),)));
            });
          });
        }
        widget.onSignedIn();
      } catch (e) {
        showToast();
        print('Error: $e');
      }
    }
  }

  void irAlLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void irAlRegistro() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  } void irAlRegistroRemis() {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginRemis(auth: Auth(),
            ),
      ),
    );
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          fondo,
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _formType == FormType.login?Text(
                    "Ingresá tu cuenta registrada en el sistema.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ):Text("Registrá una cuenta en el sistema completando tus datos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),),
                  Container(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: buildInputs() + buildSubmitButtons(),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('email'),keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(labelText: 'Correo',contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)), icon: Icon(Icons.email)),
            validator: VerificarCampoEmail.validar,
            onSaved: (String value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(
                labelText: 'Contraseña',contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)), icon: Icon(Icons.vpn_key)),
            obscureText: true,
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _password = value,
          ),
        ),
      ];
    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('email'),keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(labelText: 'Correo',contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)), icon: Icon(Icons.email)),
            validator: VerificarCampoEmail.validar,
            onSaved: (String value) => _email = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('password'),
            decoration: InputDecoration(
                labelText: 'Contraseña',contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)), icon: Icon(Icons.vpn_key)),
            obscureText: true,
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _password = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('nombre'),
            decoration: InputDecoration(labelText: 'Nombre y Apelido',contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),icon: Icon(Icons.person)),
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _nombre = value,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: Key('tel'),keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: 'Celular',contentPadding: EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 10.0),border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),icon: Icon(Icons.phone)),
            validator: VerificarCampoPass.validar,
            onSaved: (String value) => _tel = value,
          ),
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 48,top: 8,right: 8),
          child: Material(borderRadius: BorderRadius.circular(20),elevation: 5,color: Colors.orange,
                    child: MaterialButton(
              key: Key('signIn'),
              
              child: Text('Ingresar',
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: validarEnviar,
            ),
          ),
        ),
        
        InkWell(onTap: irAlRegistro,
            child: Padding(
              padding: const EdgeInsets.only(top:15,right: 10),
              child: Text('¿Aún no tenés una cuenta?',textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15.0,color: Colors.white54),),
            ),),  
            InkWell(onTap: irAlRegistroRemis,
            child: Padding(
              padding: const EdgeInsets.only(top:15,right: 10),
              child: Text('¿Queres Trabajar con nosotros?',textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15.0,color: Colors.white54),),
            ),),
      ];
    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 48,top: 8,right: 8),
          child: Material(borderRadius: BorderRadius.circular(20),elevation: 5,color: Colors.orange,                    
                    child: MaterialButton(
              
              child: Text('Crear cuenta', style: TextStyle(fontSize: 20.0, color: Colors.white )),
              onPressed: validarEnviar,
            ),
          ),
        ),
         InkWell(onTap: irAlLogin,
            child: Padding(
              padding: const EdgeInsets.only(top:15,right: 10),
              child: Text('Ya tengo una cuenta.',textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 15.0,color: Colors.white54),),
            ),),
      ];
    }
  }
}

/* @override
  Widget build(BuildContext context) {
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
                        CupertinoPageRoute(builder: (context) => MenuCliente()));
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
                        CupertinoPageRoute(builder: (context) => MenuCliente()));
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
*/
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
