import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/customer_card.dart';

import 'Sidebar.dart';

const spinkit = SpinKitRotatingCircle(
  color: Colors.white,
  size: 50.0,
);

class Spinner extends StatelessWidget {
  const Spinner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => CustomerCard()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {

            },
          )
        ],
      ),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            color: Color(0xFF4267B2),
            child: spinkit
        ),
      ),
    );
  }
}