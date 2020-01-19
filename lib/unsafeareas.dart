

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:suraksha/main.dart';
import 'home.dart';

String loc=" ";


class CustomCard extends StatelessWidget {
  CustomCard({@required this.add, this.lat, this.long});

  final add,lat,long;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                Text(add),
              ],
            )
        )
    );
  }
}


class unsafearea extends StatelessWidget {

  Future<String> checkstat(double a, double b)
  async {
    placemark = await Geolocator().placemarkFromCoordinates(a, b);
    loc=placemark[0].name + ", " + placemark[0].subLocality + ", " +
        placemark[0].locality + ", " + placemark[0].administrativeArea +
        ", " + placemark[0].country + " - " + placemark[0].postalCode;
    print("Location in future:"+loc);

    double x=await Geolocator().distanceBetween(lat, long, a,b);
    print(x);
    if(x<=10000.0) {
      Map<String,dynamic> data = <String,dynamic>{
        "Address": loc,
      };
      await db.collection(s).document(loc).setData(data).whenComplete(() {
        print("Location Added");
      }).catchError((e) => print(e));
      return "Hello";
    }
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("Unsafe Areas", style: TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("Unsafe").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) return new Text('No forms are available now!!!\n\nPlease try again later.',style: TextStyle(fontSize: 15));
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Retrieving Locations...',
                      style: TextStyle(fontSize: 20),);
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((
                          DocumentSnapshot document) {
                        Widget check;
                        Future<String> d=checkstat(double.parse(document['Latitude']),double.parse(document['Longitude']));
                        if (d != null) {
                          print("Location in main:"+loc);
                            check = CustomCard(
                              lat: document['Latitude'],
                              long: document['Longitude'],
                              add: loc
                              );
                        }
                        else {
                          check = new Container();
                        }
                       return new Container(child: check);
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ),
      );
  }
}