import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {

  AddressCard({this.val});
  final String val;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey,
      ),
      height: 20.0,
      width: MediaQuery.of(context).size.width-20,
      child: Text('$val'),
    );
  }
}
