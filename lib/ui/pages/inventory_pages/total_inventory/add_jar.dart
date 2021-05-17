import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/load_jar_successful.dart';

import 'add_jar_successful.dart';

class AddJarPage extends StatefulWidget {
  @override
  _AddJarPageState createState() => _AddJarPageState();
}

class _AddJarPageState extends State<AddJarPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Inventory'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  color: Colors.blue,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Add Jar In Stock',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5),
                    child: Text(
                      'Load Jar',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.schedule,
                  color: Colors.black,
                  size: 20,
                ),
                Text(
                  '8:30PM',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 10, 40, 0),
                  child: Container(
                    color: Colors.black26,
                    padding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10),
                    child: Center(
                      child: Text(
                        'Previous   Cool Jar-18lt',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 80,
                    height: 50,
                    child: Card(
                      elevation: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 10, 40, 0),
                  child: Container(
                    color: Colors.black26,
                    padding: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10),
                    child: Center(
                      child: Text(
                        'Previous Bottle Jar-20lt',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 80,
                    height: 50,
                    child: Card(
                      elevation: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 10, 40, 0),
                  child: Container(
                    color: Colors.black26,
                    padding: EdgeInsets.fromLTRB(37, 10, 37, 10),
                    child: Text(
                      'Cool Jar-18lt',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 80,
                    height: 50,
                    child: Card(
                      elevation: 1.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 10, 40, 0),
                  child: Container(
                    color: Colors.black26,
                    padding: EdgeInsets.fromLTRB(36, 10, 36, 10),
                    child: Text(
                      'Cool Jar-18lt',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 80,
                    height: 50,
                    child: Card(
                      elevation: 1.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                shape: RoundedRectangleBorder(),
                color: Colors.grey[350],
                onPressed: () {
                  //showModalBottomSheet
                },
                child: Text(
                  'Reason for editing (Optional)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              // ignore: deprecated_member_use
              child: RaisedButton(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddJarSuccessfulPage()),
                  );
                },
                child: Text(
                  'Submit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
