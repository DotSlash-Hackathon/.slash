import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: camel_case_types
class updateDetails extends StatefulWidget {
  updateDetails({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _updateDetailsstate createState() => new _updateDetailsstate();
}

// ignore: camel_case_types
class _updateDetailsstate extends State<updateDetails> {
  final db=Firestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseUser user;


  TextEditingController _ec1 = new TextEditingController();
  TextEditingController _ec2 = new TextEditingController();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    auth.onAuthStateChanged.listen((u) {
      setState(() => user = u);
    });
  }


  void submit()  async{
    if(_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String,String> data = <String,String>{
        "Emergency Contact 1": _ec1.text,
        "Emergency Contact 2": _ec2.text,
      };
      await db.collection("Users").document(s).updateData(data).whenComplete(() {
        print("Emergency Contacts Updated");
      }).catchError((e) => print(e));
      Toast.show("Emergency Contact Updated Successfully", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text("Change Emergency Contacts", style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/img.jpg"),
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Padding(padding:EdgeInsets.all(10),
            child: Form(key: _formKey,
              child: Theme(
                data: ThemeData(
                  brightness: Brightness.dark,
                  accentColor: Colors.lightBlue,
                  primaryColor: Colors.blueAccent,
                  inputDecorationTheme: InputDecorationTheme(
                    labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(prefixIcon: Icon(Icons.phone),hintText: 'Enter phone no as +91xxxxxxxxxx',
                        labelText: 'Emergency Contact 1',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      validator: (value){
                        if(value.isEmpty)
                          return 'Please enter Emergency Contact 1';
                        return null;
                      },
                      controller: _ec1,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(prefixIcon: Icon(Icons.phone),hintText: 'Enter phone no as +91xxxxxxxxxx',
                        labelText: 'Emergency Contact 2',
                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                      ),
                      validator: (value){
                        if(value.isEmpty)
                          return 'Please enter Emergency Contact 2';
                        return null;
                      },
                      controller: _ec2,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: new MaterialButton(
                        height: 60,
                        minWidth: 200,
                        color: Colors.white,
                        textColor: Colors.blueAccent,
                        child: Text('Change Password', style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                        splashColor: Colors.white12,
                        onPressed: submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}