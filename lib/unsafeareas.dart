import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'home.dart';
import 'address_card.dart';

String d = " ";
List<String> loc;
List<Widget> cardlist = [];

void cardadd() {
  for(int i;i<=10;i++){
    cardlist.add(AddressCard(val: loc[i],));
  }
}


//class CustomCard extends StatelessWidget {
//  CustomCard({@required this.add});
//
//  final add;
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//        child: Container(
//            padding: const EdgeInsets.only(top: 10),
//            child: Column(
//              children: <Widget>[
//                Text(add),
//              ],
//            )));
//  }
//}

class unsafearea extends StatelessWidget {
  Future<void> create(double x, double y) async {
    d = await checkstat(x, y);
  }

  Future<String> checkstat(double a, double b) async {
    placemark = await Geolocator().placemarkFromCoordinates(a, b);
    loc.add(placemark[0].name +
        ", " +
        placemark[0].subLocality +
        ", " +
        placemark[0].locality +
        ", " +
        placemark[0].administrativeArea +
        ", " +
        placemark[0].country +
        " - " +
        placemark[0].postalCode);
    cardadd();
    //print("Location in future:"+loc);

    double x = await Geolocator().distanceBetween(lat, long, a, b);
    print(x);
    if (x <= 10000.0) {
      return "Hello";
    } else
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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              if (!snapshot.hasData)
                return new Text(
                    'No forms are available now!!!\n\nPlease try again later.',
                    style: TextStyle(fontSize: 15));
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text(
                    'Retrieving Locations...',
                    style: TextStyle(fontSize: 20),
                  );
                default:
                  return ListView(
                    children: cardlist,
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

//snapshot.data.documents
//    .map((DocumentSnapshot document) {
//Widget check;
//create(double.parse(document['Latitude']),
//double.parse(document['Longitude']));
////  print("Location in main:"+loc);
//if (d == "Hello") {
//loc.forEach(void f(String s)){
//for()
//check = AddressCard();
//};
//}
//else
//check = Container();
//return new Container(child: check);
//}).toList(),