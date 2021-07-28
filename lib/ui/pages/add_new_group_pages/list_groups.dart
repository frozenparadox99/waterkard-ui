import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/add_new_group_pages/add_group.dart';
import 'package:waterkard/ui/pages/add_new_group_pages/edit_group.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:waterkard/ui/widgets/Spinner.dart';

import '../vendor_login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const kBackgroundColor = Color(0xffF6F6F6);
const kAccentColor = Color(0xff03A5E1);
const kBlackColor = Color(0xFF212121);
const kGreyColor = Color(0x50212121);
const kWhiteColor = Color(0xFFFFFFFF);
const kWhiteGreyColor = Color(0xFFF9F9F9);
const kGreenColor = Color(0xFF36B552);
const kOrangeColor = Color(0xFFFF9C41);
const kBlueColor = Color(0xFF3B64F4);
const kJeniusCardColor = Color(0xFF03A5e1);
const kMasterCardColor = Color(0xFFF5F5F5);
const kGradientSlideButton = [const Color(0xFF3B64F4), const Color(0xFF6822FD)];


class TransactionModel {
  String name;

  Color colorType;

  String usersInGroup;
  String information;
  String driverAssigned;
  String date;


  TransactionModel(this.name, this.colorType,
      this.usersInGroup, this.information, this.driverAssigned, this.date,);
}

List<TransactionModel> transactions = transactionData
    .map((item) => TransactionModel(
    item['name'],

    item['colorType'],

    item['usersInGroup'],
    item['information'],
    item['driverAssigned'],
    item['date'],
    ))
    .toList();

var transactionData = [
  {
    "name": "Group 1",

    "colorType": kOrangeColor,

    "usersInGroup": "200",
    "information": "Assigned To:",
    "driverAssigned": "Michael Ballack",
    "date": "12 Feb 2020",

  },
  {
    "name": "Group 2",

    "colorType": kGreenColor,

    "usersInGroup": "352",
    "information": "Assigned To:",
    "driverAssigned": "Patrick Star",
    "date": "10 Feb 2020",

  },
  {
    "name": "Group 3",

    "colorType": kOrangeColor,

    "usersInGroup": "53",
    "information": "Assigned To:",
    "driverAssigned": "Driver 3",
    "date": "09 Feb 2020",

  }
];






class ListGroups extends StatefulWidget {
  const ListGroups({Key key}) : super(key: key);

  @override
  _ListGroupsState createState() => _ListGroupsState();
}

class _ListGroupsState extends State<ListGroups> {

  String uid;
  List<TransactionModel> allGroupsForVendor = [];
  bool isLoading = false;


  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllGroups();
  }

  void getAllGroups () async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/group/all?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["groups"]!=null){
        List<dynamic> receivedProducts = decodedJson["data"]["groups"];
        List<dynamic> formatted = receivedProducts.map((e) => {
          "name":e["name"],
          "colorType": kOrangeColor,
          "usersInGroup": e["newcust"].length.toString(),
          "information": "Assigned To:",
          "driverAssigned":e["newdriv"].length == 0 ? "No Driver" :e["newdriv"][0]["name"],
          "date":e["newdriv"].length == 0 ? "No Number" :e["newdriv"][0]["mobileNumber"],
        }).toList();



        setState(() {
          allGroupsForVendor = formatted.map((item) => TransactionModel(
            item['name'],

            item['colorType'],

            item['usersInGroup'],
            item['information'],
            item['driverAssigned'],
            item['date'],
          ))
              .toList();
          isLoading = false;
        });

      }

    }
  }
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Spinner();
    }
    return Scaffold(
      backgroundColor: Color(0xFF4267B2),
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Groups'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddGroup()));
            },
          ),
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
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            )
        ),

        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            // Card Account Section
            SizedBox(height: 40,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("All Groups", style: TextStyle(color: Colors.black, fontSize: 40),),
                  ),

                ],
              ),
            ),



            // Last Transaction Section
            Padding(
                padding:
                EdgeInsets.only(left: 24, top: 20, bottom: 16, right: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'View Groups',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kBlackColor,
                      ),
                    ),

                  ],
                )),
            Container(

              height: 190,
              child: ListView.builder(
                padding: EdgeInsets.only(left: 16, right: 8),
                scrollDirection: Axis.horizontal,
                itemCount: allGroupsForVendor.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8),
                    height: 190,
                    width: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x04000000),
                            blurRadius: 10,
                            spreadRadius: 10,
                            offset: Offset(0.0, 8.0))
                      ],
                    ),
                    child: Stack(
                      children: <Widget>[

                        Positioned(
                          top: 16,
                          left: 16,
                          child: Text(
                            allGroupsForVendor[index].name,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: allGroupsForVendor[index].colorType),
                          ),
                        ),
                        Positioned(
                          top: 50,
                          left: 16,
                          child: Text(

                                "Users: ${allGroupsForVendor[index].usersInGroup}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: allGroupsForVendor[index].colorType),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 90,
                          child: Text(
                            allGroupsForVendor[index].information,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kGreyColor),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 60,
                          child: Text(
                            allGroupsForVendor[index].driverAssigned,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: kBlackColor),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 22,
                          child: Text(
                            allGroupsForVendor[index].date,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kGreyColor),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          bottom: 16,
                          child: Image.asset(
                            "assets/profile_user.jpg",
                            height: 22,
                            width: 33,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            // Padding(
            //   padding:
            //   EdgeInsets.only(left: 24, top: 32, bottom: 16, right: 24),
            //   child: Text(
            //     'Edit Groups',
            //     style: TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w700,
            //       color: kBlackColor,
            //     ),
            //   ),
            // ),

            // GroupCard("Group 1",200),
            // GroupCard("Group 2",100),
            // GroupCard("Group 3",400),
            // GroupCard("Group 4",150),

            // ...allGroupsForVendor.map((e) =>
            //     GroupCard(e.name, e.usersInGroup)
            // ).toList(),





          ],
        ),
      ),
    );
  }
}

class GroupCard extends StatelessWidget {
  final String groupName;
  final String customers;

   GroupCard(this.groupName,this.customers);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      margin: EdgeInsets.only(bottom: 8),
      height: 68,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Color(0x04000000),
                blurRadius: 10,
                spreadRadius: 10,
                offset: Offset(0.0, 8.0))
          ],
          color: kWhiteColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kWhiteGreyColor,
                  image: DecorationImage(
                    image: AssetImage("assets/profile_user.jpg"),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    this.groupName,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: kBlackColor),
                  ),
                  Text(
                    "Total Users: ${this.customers}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kGreyColor),
                  )
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[

              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => EditGroup()));
                },
              ),

              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () {
                  print("Pressed");
                },
              ),
              SizedBox(
                width: 16,
              ),
            ],
          )
        ],
      ),
    );
  }
}
