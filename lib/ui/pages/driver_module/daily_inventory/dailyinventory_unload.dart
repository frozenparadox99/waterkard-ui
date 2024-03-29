import 'package:flutter/material.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/driver_module/daily_inventory/dailyinventory_load.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_load.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/unload_jar_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/Spinner.dart';


import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

String truncateString(String data, int length) {
  return (data.length >= length) ? '${data.substring(0, length)}...' : data;
}


class DriverDailyInventoryUnloadPage extends StatefulWidget {
  @override
  _DriverDailyInventoryUnloadPageState createState() => _DriverDailyInventoryUnloadPageState();
}

class _DriverDailyInventoryUnloadPageState extends State<DriverDailyInventoryUnloadPage> {
  String currentDriverStateSelected, currentProductStateSelected;
  List dailyInvForVendor = [];
  bool isLoading = false;
  void initState() {
    super.initState();
    currentDriverStateSelected = "";
    currentProductStateSelected = "";
    getTotalInventory();
  }

  void getTotalInventory () async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("driverVendor");
    var driverId = prefs.getString("driverId");
    print(id);

    if(id!=null){
      var now = new DateTime.now();
      var date = "${now.day}/${now.month}/${now.year}";
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/inventory/daily?vendor=$id&date=$date&driver=$driverId";
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
            "load18": (e["unloadReturned18"]+e["unloadEmpty18"]).toString(),
            "load20": (e["unloadReturned20"]+e["unloadEmpty20"]).toString(),
          }).toList();
        }


        setState(() {
          dailyInvForVendor = formatted;
          isLoading = false;
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

    if(isLoading){
      return Spinner();
    }

    return Scaffold(
      drawer: SidebarDriver(),
      appBar: AppBar(
        title: Text('Daily Inventory'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.remove_circle),
          //   onPressed: ()  {
          //     Navigator.pushReplacement(
          //         context, MaterialPageRoute(builder: (context) => UnloadJarPage()));
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.filter_alt),
          //   onPressed: ()  {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: ()  {},
          // ),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverDailyInventoryLoadPage()),
                    );
                  },
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
            // SizedBox(
            //   height: 20,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     OutlinedButton(
            //       onPressed: () {},
            //       child: Text('Load Jar'),
            //     ),
            //     SizedBox(
            //       width: 20,
            //     ),
            //     OutlinedButton(
            //       onPressed: () {},
            //       child: Text('Unload Jar'),
            //     ),
            //   ],
            // ),
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
                            'Daily Unload',
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
                              '18L Unload',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '20L Unload',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Information',
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
