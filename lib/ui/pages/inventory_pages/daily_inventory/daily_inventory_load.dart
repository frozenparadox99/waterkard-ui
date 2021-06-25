import 'package:flutter/material.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'daily_inventory_unload.dart';
import 'load_jar_page.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}...' : data;
}


class DailyInventoryLoadPage extends StatefulWidget {
  @override
  _DailyInventoryLoadPageState createState() => _DailyInventoryLoadPageState();
}

class _DailyInventoryLoadPageState extends State<DailyInventoryLoadPage> {
  String currentDriverStateSelected, currentProductStateSelected;
  List dailyInvForVendor = [];
  void initState() {
    super.initState();
    currentDriverStateSelected = "";
    currentProductStateSelected = "";
    getTotalInventory();
  }

  void getTotalInventory () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      var now = new DateTime.now();
      var date = "${now.day}/${now.month}/${now.year}";
      String apiURL =
          "http://192.168.29.79:4000/api/v1/vendor/inventory/daily?vendor=$id&date=$date";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["dailyInv"]!=null){
        List<dynamic> receivedProducts = decodedJson["data"]["dailyInv"];
        List<dynamic> formatted = [];
        if(receivedProducts.length!=0){
          formatted = receivedProducts.map((e) => {
            "driverName":truncateString( e["driver"]["name"], 9),
            "load18": e["load18"].toString(),
            "load20": e["load20"].toString(),
          }).toList();
        }


        setState(() {
          dailyInvForVendor = formatted;
        });

      }

    }
  }

  Row tableBuilder(driverName,load18, load20){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          driverName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),

        Text(
          load18,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Text(
          load20,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Center(
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Daily Inventory'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoadJarPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: ()  {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: ()  {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              // await FirebaseAuth.instance.signOut();
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5),
                    child: Text(
                      'Load Jar',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DailyInventoryUnloadPage()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5),
                    child: Text(
                      'Unload Jar',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Load Jar'),
                ),
                SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Unload Jar'),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Daily Load',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Driver',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '18L Load',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '20L Load',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        ...dailyInvForVendor.map((e) =>
                            tableBuilder(e["driverName"],e["load18"],e["load20"])
                        ).toList(),



                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Text(
                        //       'JK',
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //     Text(
                        //       '10',
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //     Center(
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(
                        //           Icons.delete,
                        //           color: Colors.red,
                        //           size: 18,
                        //         ),
                        //       ),
                        //     ),
                        //     Center(
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(
                        //           Icons.edit,
                        //           color: Colors.black,
                        //           size: 18,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
