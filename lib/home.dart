import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/unsafeareas.dart';
import 'package:suraksha/updateDetails.dart';
import 'cnfusr.dart';
import 'package:gps/gps.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'main.dart';
import 'package:toast/toast.dart';

final db=Firestore.instance;
String name;
double dist,lat,long;
List<Placemark> placemark;
// ignore: camel_case_types
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GpsLatlng latlng;

  String address, link;
  String temp1="",temp2="",ec1,ec2,l1,l2;

  StreamSubscription<HardwareButtons.VolumeButtonEvent> _lockButtonSubscription;

  @override
  void dispose() {
    super.dispose();
    _lockButtonSubscription?.cancel();
  }

  @override
  void initState() {
    String test="";
    super.initState();
    _lockButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
      test=event.toString();
      if(test=="VolumeButtonEvent.VOLUME_UP")
        sos();
    });

  }

  void initGps() async {
    var location = Location();
    bool enabled = await location.serviceEnabled();
    if(enabled==false)
      enabled = await location.requestService();
    if(enabled==true) {
      final  gps = await Gps.currentGps();
      latlng = gps;
      String temp = latlng.toString();
      lat = 0.0;
      long = 0.0;
      int i = 0;
      temp1 = "";
      temp2 = "";
      while (temp[i] != ',') {
        temp1 += temp[i];
        i++;
      }
      i += 2;
      while (i != temp.length) {
        temp2 += temp[i];
        i++;
      }
      lat = double.parse(temp1);
      long = double.parse(temp2);
      placemark = await Geolocator().placemarkFromCoordinates(lat, long);
      address = "I am in emergency!\nThis is my current location: "+placemark[0].name + ", " + placemark[0].subLocality + ", " +
          placemark[0].locality + ", " + placemark[0].administrativeArea +
          ", " + placemark[0].country + " - " + placemark[0].postalCode+"\nCoordinates: "+temp1+","+temp2;
      link="Google Map Link: http://maps.google.com/maps?z=18&q="+temp1+","+temp2;
    }
    else
      initGps();
  }
  void sos() async {
    initGps();
    sms();
    Map<String,dynamic> data = <String,dynamic>{
        "Latitude": temp1,
        "Longitude": temp2,
      };
      await db.collection("Unsafe").add(data).whenComplete(() {
        print("Location Added");
      }).catchError((e) => print(e));
      //Toast.show("Location Submitted Successfuly", context, duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
  }
  sms(){
    SmsSender sender = new SmsSender();
    String add = '+919913971152';
    SmsMessage message = new SmsMessage(add, address);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      }
      else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
    SmsMessage message1 = new SmsMessage(add, link);
    message1.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      }
      else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    DocumentReference documentReference = db.collection("Users").document(s);
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
         ec1 = datasnapshot.data['Emergency Contact 1'].toString();
         ec2 = datasnapshot.data['Emergency Contact 2'].toString();
      }
      print("ec1="+ec1);
      print("ec2="+ec2);
    });
    sender.sendSms(message1);
    message = new SmsMessage(ec1, address);
    sender.sendSms(message);
    message1 = new SmsMessage(ec1, link);
    sender.sendSms(message1);
    message = new SmsMessage(ec2, address);
    sender.sendSms(message);
    message1 = new SmsMessage(ec2, link);
    sender.sendSms(message1);
    Toast.show("Location sent successfully!!!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM); //When displaying, here it shows [Instance of 'Placemark']
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Suraksha",style: TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Image(
            image: AssetImage("assets/img.jpg"),
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
            color: Colors.black54, //lightens the image
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  minWidth: 100.0,
                  height: 50.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  splashColor: Colors.redAccent,
                  child: Text("SOS",style: TextStyle(color: Colors.white),),
                  onPressed: sos,
                ),
                Padding(padding: EdgeInsets.only(top: 20),),
                MaterialButton(
                  color: Colors.white,
                  minWidth: 100.0,
                  height: 50.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  splashColor: Colors.white70,
                  child: Text("Check Status",style: TextStyle(color: Colors.redAccent),),
                  onPressed: () {
                    initGps();
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => unsafearea()
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.lightBlue),
                  accountName: Text("$name\n"+s,style: TextStyle(fontSize: 18.0),),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle,
                      image: DecorationImage(fit: BoxFit.fill,
                          image: AssetImage("assets/logo.png")),
                    ),
                  ),
                  accountEmail: null,
                ),
              ),
              ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home,color: Colors.redAccent),
                onTap: () {
                  MyHomePage();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Change Emergency Contacts'),
                leading: Icon(Icons.contacts,color: Colors.orange,),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => updateDetails()
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Change Password'),
                leading: Icon(Icons.lock_outline,color: Colors.blueAccent),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => cnfusr()
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Log Out'),
                leading: Icon(Icons.exit_to_app,color: Colors.black,),
                onTap: () async {
                  Toast.show("You have successfully Logged Out", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('email');
                  prefs.remove('password');
                  prefs.remove('name');
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 500), () {
                    exit(1);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
