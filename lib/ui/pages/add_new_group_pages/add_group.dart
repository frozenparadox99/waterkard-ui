import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/add_new_group_pages/list_groups.dart';

import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AddGroup extends StatefulWidget {
  const AddGroup({Key key}) : super(key: key);

  @override
  _AddGroupState createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {

  String uid;

  String currentStateSelected;
  String newGroupName;
  String newGroupDescription;

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Groups'),
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
                    child: Text("Create Group", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("One Driver Per Group", style: TextStyle(color: Colors.white, fontSize: 18),),
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
                                      newGroupName = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Enter Group Name",
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
                                      newGroupDescription = val;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Group Description",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),


                            ],
                          ),
                        ),
                        SizedBox(height: 40,),

                        InkWell(
                          onTap: ()async{
                            print(newGroupDescription);
                            print(newGroupName);
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var id = prefs.getString("vendorId");
                            print(id);
                            if(id!=null){
                              String apiURL =
                                  "$API_BASE_URL/api/v1/vendor/group";
                              var response = await http.post(Uri.parse(apiURL),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body:jsonEncode( <String, dynamic>{
                                    "name":newGroupName,
                                    "description":newGroupDescription,
                                    "vendor":id
                                  }));
                              var body = response.body;

                              var decodedJson = jsonDecode(body);

                              print(body);
                              print(decodedJson);

                              if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => ListGroups()));
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
                                context, MaterialPageRoute(builder: (context) => ListGroups()));
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
