import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:suraksha/loc.dart';
import 'cnfusr.dart';
import 'register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'delayed_animation.dart';
import 'home.dart';
import 'loc.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

bool ot,ot1;
String s="";

void main() {
  //SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => MyHomePage(),
        '/loginpage': (BuildContext context) => MyApp(),
        '/display': (BuildContext context) => display(),
      },
      theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          accentColor: Colors.blueAccent
      ),
    );
  }
}
class Login extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Login> with SingleTickerProviderStateMixin {
  final int delayedAmount = 500;
  double _scale;
  bool temp=false;

  AnimationController _controller;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNo;
  String pass;
  //FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> credentials(String email, String password, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _email.text);
    prefs.setString('password', _password.text);
    prefs.setString('name', name);
    return prefs.commit();
  }

  Future<bool> settemp(bool temp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('temp', true);
  }

  Future<bool> gettemp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    temp = prefs.getBool('temp');
    return temp;
  }

  Future<void> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    s=prefs.getString("email");
    pass=prefs.getString("password");
    name=prefs.getString("name");
  }

  /*Future<String> getPass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pass=prefs.getString("password");
    return pass;
  }*/

  void change() async {
    s = _email.text;
    if (_formKey.currentState.validate()) {
      DocumentReference documentReference = db.collection("Users").document(s);
      documentReference.get().then((datasnapshot) async {
        if (datasnapshot.exists) {
          pass = datasnapshot.data['Password'].toString();
          if (_password.text == pass) {
            name =datasnapshot.data['Name'].toString();
            settemp(true);
            credentials(s, pass, name).then((bool comitted) {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/homepage');
            });
          }
          else
            Toast.show("Invalid Password!!!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        }
        else
          Toast.show("User not registered!!!", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
      );
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    ot = true;
    ot1 = true;
    _email.text=null;
    _password.text=null;
    gettemp().whenComplete(() {
      setState(() {
        this.temp = temp;
      });
      if(temp == true) {
        getCredentials().whenComplete(updatePage);
      }
    });
    super.initState();
  }
  void updatePage(){
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/homepage');
  }
  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(
              image: AssetImage("assets/img.jpg"),
              fit: BoxFit.cover,
              color: Colors.black54,
              colorBlendMode: BlendMode.darken,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Form(key: _formKey,
                child: Theme(
                  data: ThemeData(
                    brightness: Brightness.dark,
                    accentColor: Colors.lightBlue,
                    primaryColor: Colors.blueAccent,
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: color, fontSize: 20.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      AvatarGlow(
                        endRadius: 90,
                        duration: Duration(seconds: 2),
                        glowColor: color,
                        repeat: true,
                        repeatPauseDuration: Duration(seconds: 2),
                        startDelay: Duration(seconds: 1),
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset("assets/complaint.png"),
                            radius: 50.0,
                          ),
                        ),
                      ),
                      DelayedAimation(
                        child: Text("Welcome to Suraksha", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35.0,
                            color: color),
                        ),
                        delay: delayedAmount + 500,
                      ),
                      SizedBox(height: 30.0),
                      DelayedAimation(
                        child: TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(prefixIcon: Icon(Icons.email),hintText: 'Email Id',
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                          ),
                          validator: (value){
                            if(value.isEmpty)
                              return 'Please enter Email Address';
                            return null;
                          },
                          controller: _email,
                        ),
                        delay: delayedAmount + 1000,
                      ),
                      SizedBox(height: 15.0),
                      DelayedAimation(
                        child: TextFormField(
                          autofocus: false,
                          obscureText: ot,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(prefixIcon: Icon(Icons.lock),hintText: 'Password',
                            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                            suffixIcon: GestureDetector(
                              onTap: () { setState(() {ot = !ot;}); },
                              child: Icon(ot ? Icons.visibility : Icons.visibility_off,
                                semanticLabel: ot ? 'show password' : 'hide password',
                              ),
                            ),
                          ),
                          validator: (value){
                            if(value.isEmpty)
                              return 'Please enter Password';
                            return null;
                          },
                          controller: _password,
                        ),
                        delay: delayedAmount + 1500,
                      ),
                      SizedBox(height: 50.0),
                      DelayedAimation(
                        child: GestureDetector(
                          onTapDown: _onTapDown,
                          onTapUp: _onTapUp,
                          child: Transform.scale(
                            scale: _scale,
                            child: _animatedButtonUI,
                          ),
                        ),
                        delay: delayedAmount + 2000,
                      ),
                      SizedBox(height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DelayedAimation(
                            child: FlatButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: () async { Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => cnfusr()));
                              },
                              child: Text('Forgot Password', style: TextStyle(color: Colors.white70)),
                            ),
                            delay: delayedAmount + 2500,
                          ),
                          DelayedAimation(
                            child: Text("|"),
                            delay: delayedAmount + 2500,
                          ),
                          DelayedAimation(
                            child: FlatButton(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              onPressed: () async { Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => register()));
                              },
                              child: Text('Register Now', style: TextStyle(color: Colors.white70)),
                            ),
                            delay: delayedAmount + 2500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
    height: 60,
    width: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      /*gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blueAccent,
          Colors.pinkAccent,
        ],
      )*/
      color: Colors.white,
    ),
    child: Center(
      child: /*MaterialButton(
        //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () async { launch('https://bits-grievance-1c10f.firebaseapp.com/resetPassword.html'); },
        child: Text('Log In', style: TextStyle(color: Colors.blueAccent)),
      ),*/
      Text(
        'Log In',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    ),
  );

  void _onTapDown(TapDownDetails details) async {
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      change();
    });
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}