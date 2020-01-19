import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
class CustomCard extends StatelessWidget {
  CustomCard({@required this.location});

  final location;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(location,style: TextStyle(fontSize: 20)),            
              ],
            )
        )
    );
  }
}

class display extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("History", style: TextStyle(color: Colors.white)),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Unsafe').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                if (!snapshot.hasData) return new Text('No forms are available now!!!\n\nPlease try again later.',style: TextStyle(fontSize: 15));
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text('Retrieving Forms...',style: TextStyle(fontSize: 20),);
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return CustomCard(
                          location: document['Address'],
                        );
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