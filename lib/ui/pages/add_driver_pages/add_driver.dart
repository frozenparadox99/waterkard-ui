import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:waterkard/ui/pages/add_driver_pages/all_drivers.dart';

import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AddDriver extends StatefulWidget {
  const AddDriver({Key key}) : super(key: key);

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {

  String uid;
  final _groupNames = [
    {
      "display": "Group 1",
      "value": "G1",
    },
    {
      "display": "Group 2",
      "value": "G2",
    },
    {
      "display": "Group 3",
      "value": "G3",
    },
  ];

  String currentStateSelected;
  String newMobileNumber;
  String newDriverName;

  List<dynamic> allGroupNamesAndIds = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllGroups();
  }
  void getAllGroups () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "http://192.168.29.79:4000/api/v1/vendor/group/all?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["groups"]!=null){
        List<dynamic> receivedGroups = decodedJson["data"]["groups"];
        receivedGroups.forEach((ele) {
          setState(() {
            allGroupNamesAndIds.add({
              "display":ele["name"],
              "value":ele["_id"]
            }
            );
          });

        });
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {},
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
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(

          color: Color(0xFF4267B2),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("Add Driver", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("You can assign a group as well", style: TextStyle(color: Colors.white, fontSize: 18),),
                  )
                ],
              ),
            ),
            Expanded(child: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[200])
                                    )
                                ),
                                child: TextField(
                                  onChanged: (val){
                                    setState(() {
                                      newDriverName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Name of Driver",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[200])
                                    )
                                ),
                                child: TextField(
                                  onChanged: (val){
                                    setState(() {
                                      newMobileNumber = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Mobile Number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,


                                ),
                                child: DropDownFormField(
                                  validator: (dynamic value) {
                                    if (value == null) {
                                      return 'State cannot be empty';
                                    }
                                    return null;
                                  },
                                  titleText: 'Assign Group',
                                  value: currentStateSelected,
                                  onSaved: (value) {
                                    setState(() {
                                      currentStateSelected = value;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      currentStateSelected = value;
                                    });
                                  },
                                  dataSource: allGroupNamesAndIds,
                                  textField: 'display',
                                  valueField: 'value',
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[200])
                                    )
                                ),

                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),

                        InkWell(
                          onTap: () async {
                            print(currentStateSelected);
                            print(newDriverName);
                            print(newMobileNumber);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var id = prefs.getString("vendorId");
                            print(id);
                            if(id!=null){
                              String apiURL =
                                  "http://192.168.29.79:4000/api/v1/vendor/driver";
                              var response = await http.post(Uri.parse(apiURL),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body:jsonEncode( <String, dynamic>{
                                    "name":newDriverName,
                                    "mobileNumber":"+91$newMobileNumber",
                                    "vendor":id,
                                    "group":currentStateSelected
                                  }));
                              var body = response.body;

                              var decodedJson = jsonDecode(body);

                              print(body);
                              print(decodedJson);

                              if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => AllDrivers()));
                              }


                            }

                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              color: Color(0xFF4267B2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Submit",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => AllDrivers()));
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              color: Color(0xffFF2E63),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Cancel",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),

                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                      ],
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
