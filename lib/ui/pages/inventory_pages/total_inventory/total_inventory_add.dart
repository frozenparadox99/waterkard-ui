import 'package:flutter/material.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/add_jar.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/total_inventory_remove.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TotalInventoryAddPage extends StatefulWidget {
  @override
  _TotalInventoryAddPageState createState() => _TotalInventoryAddPageState();
}

class _TotalInventoryAddPageState extends State<TotalInventoryAddPage> {

  List<dynamic> totalInvForVendor = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotalInventory();
  }

  void getTotalInventory () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/inventory/total?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["totalInventory"]!=null){
        List<dynamic> receivedProducts = decodedJson["data"]["totalInventory"]["stock"];
        List<dynamic> formatted = [];
        if(receivedProducts.length!=0){
          formatted = receivedProducts.map((e) => {
            "coolJars": e["coolJarStock"].toString(),
            "bottleJars": e["bottleJarStock"].toString(),
            "date": "${DateTime.parse(e["dateAdded"]).day+1}/${DateTime.parse(e["dateAdded"]).month}/${DateTime.parse(e["dateAdded"]).year}" ,
          }).toList();
        }


        setState(() {
          totalInvForVendor = formatted;
        });

      }

    }
  }

  Row tableEntries(date,coolJars,bottleJars){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          date,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Text(
          coolJars,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Text(
          bottleJars,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
        Center(
          child: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddJar()));
            },
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
        title: Text('Added Jars'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddJar()));
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
                      'Add Jar',
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
                          builder: (context) => TotalInventoryRemovePage()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5),
                    child: Text(
                      'Remove Jar',
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 2.0,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Cool Jars',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Bottle Jars',
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

                        ...totalInvForVendor.map((e) =>
                            tableEntries(e["date"],e["coolJars"],e["bottleJars"])
                        ).toList(),





                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Text(
                        //       '17-05-2021',
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 12,
                        //       ),
                        //     ),
                        //
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
