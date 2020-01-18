import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:gps/gps.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:toast/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sms/sms.dart';
import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Suraksha',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: MyHomePage(title: 'Suraksha'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GpsLatlng latlng;
  List<Placemark> placemark;
  String address;
  String temp1="",temp2="";
  StreamSubscription<HardwareButtons.VolumeButtonEvent> _lockButtonSubscription;

  @override
  void initState() {
    String test="";
    super.initState();
    _lockButtonSubscription = HardwareButtons.volumeButtonEvents.listen((event) {
      test=event.toString();
      if(test=="VolumeButtonEvent.VOLUME_UP")
        initGps();
    });

  }

  void initGps() async {
    var location = Location();
    bool enabled = await location.serviceEnabled();
    if(enabled==false)
      enabled = await location.requestService();
    if(enabled==true) {
      var gps = await Gps.currentGps();
      latlng = gps;
      String temp = latlng.toString();
      double lat = 0.0,
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
      print(temp1);
      print(temp2);
      lat = double.parse(temp1);
      long = double.parse(temp2);
      placemark = await Geolocator().placemarkFromCoordinates(lat, long);
      address = placemark[0].name + ", " + placemark[0].subLocality + ", " +
          placemark[0].locality + ", " + placemark[0].administrativeArea +
          ", " + placemark[0].country + " - " + placemark[0].postalCode;
      sms();
    }
    else
      initGps();
  }
  sms(){
    SmsSender sender = new SmsSender();
    String add = '+917818044311';
    SmsMessage message = new SmsMessage(add, 'I am in emergency!\nThis is my current location: '+address+'\nLatitude: '+temp1+'\nLongitude: '+temp2);
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
    Toast.show("Location sent successfully!!!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM); //When displaying, here it shows [Instance of 'Placemark']
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suraksha"),
      ),
      body: Center(
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
                onPressed: initGps,
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}