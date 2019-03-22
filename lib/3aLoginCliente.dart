import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toricar/2SelectMode.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toricar/4aMenuCliente.dart';
import 'package:toricar/auth.dart';
import 'package:toricar/authProvider.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginCliente extends StatefulWidget {
  LoginCliente({this.auth,this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginClienteState createState() => _LoginClienteState();
}
enum FormType{
  login,
  register
}

class _LoginClienteState extends State<LoginCliente> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }
  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          final String userId = await widget.auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
          Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (context) => MenuCliente()));
        } else {
          final String userId = await widget.auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
         showToast();
        print('Error: $e');
      }
    }
  }
    void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }
  void moveToRegister(){
    formKey.currentState.reset();
    setState((){
      _formType = FormType.register;
    });
  }
  /*TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();  
  @override
  void initState() {
    super.initState();
  }*/
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return <Widget>[
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        validator: EmailFieldValidator.validate,
        onSaved: (String value) => _email = value,
      ),
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (String value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        RaisedButton(
          key: Key('signIn'),
          child: Text('Login', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return <Widget>[
        RaisedButton(
          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
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

