import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/customer_card.dart';
import 'package:waterkard/ui/pages/driver_list.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_load.dart';
import 'package:waterkard/ui/pages/missing_jars_pages/tracking_jars.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:waterkard/ui/widgets/Spinner.dart';



const nameTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 32
);
const cardNameTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 22
);
const subTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 16
);
const titleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 30
);
final subTitleTextStyle = TextStyle(
    color: Colors.grey[800],
    fontWeight: FontWeight.w800,
    fontSize: 15
);
final ratingTextStyle = TextStyle(
    color: Colors.grey[800],
    fontWeight: FontWeight.w500,
    fontSize: 20
);
const detailsTitleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 32
);
const detailsSubTitleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 22
);
const courseStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 20
);



class VendorHomePage extends StatefulWidget {
  const VendorHomePage({Key key}) : super(key: key);

  @override
  _VendorHomePageState createState() => _VendorHomePageState();
}

class _VendorHomePageState extends State<VendorHomePage> {
  String uid;
  String vendorName;

  bool isLoading = false;

  List<dynamic> topCardList = [
  {
  "color":Colors.blueAccent,
  "title":"Orders",
  "desc":"Total Orders: 50",
  "page":"1",
  "misc":"Pending Orders: 0",
  },
  {
  "color":Colors.cyan,
  "title":"Customers",
  "desc":"Total Customers: 60",
  "page":"2",
  "misc":"Customers Not In A Group: 0",

  },
  {
  "color":Colors.pinkAccent,
  "title":"Jars",
  "desc": "Missing Jars: 5",
  "page":"3",
  "misc":"Date: 25/06/2021",

  },
  {
  "color":Colors.deepPurple,
  "title":"Drivers",
  "desc":"Total Drivers: 10",
  "page":"4",
  "misc":"Drivers Out For Delivery: 0",

  }
  ];

  List<dynamic> driverList = [
    {
      "color":Colors.pink[100],
      "title":"Number: 9711345582",
      "image":"https://unsplash.com/photos/c_GmwfHBDzk/download?force=true&w=640",
      "jars":"Loaded Jars: 4",
      "name":"Driver 1",
    },
    {
      "color":Colors.indigo[100],
      "title":"Number: 9711345582",
      "image":"https://unsplash.com/photos/_jOsfORtjew/download?force=true&w=640",
      "jars":"Loaded Jars: 10",
      "name":"Driver 2",
    },
    {
      "color":Colors.cyan[100],
      "title":"Number: 9711345582",
      "image":"https://unsplash.com/photos/c_GmwfHBDzk/download?force=true&w=640",
      "jars":"Loaded Jars: 12",
      "name":"Driver 3",

    },
    {
      "color":Colors.red[100],
      "title":"Number: 9711345582",
      "image":"https://unsplash.com/photos/_jOsfORtjew/download?force=true&w=640",
      "jars":"Loaded Jars: 14",
      "name":"Driver 4",

    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getHomeScreenData();
  }

  void getHomeScreenData () async {

    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/home?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["home"]!=null){

        List<dynamic> receivedProducts = decodedJson["data"]["home"]["drivers"]["details"];
        List<dynamic> formatted = [];
        if(receivedProducts.length!=0){
          formatted = receivedProducts.map((e) => {
            "color": Colors.pink[100],
            "title":"Number: ${e["mobileNumber"]}",
            "image":"https://unsplash.com/photos/_jOsfORtjew/download?force=true&w=640",
            "jars":"Group: ${truncateString(e["group"], 8)}",
            "name":e["name"],
          }).toList();
        }

        setState(() {
          topCardList[0]["desc"] = "Total Orders: ${decodedJson["data"]["home"]["totalOrders"]}";
          topCardList[1]["desc"] = "Total Customers: ${decodedJson["data"]["home"]["totalCustomers"]}";
          topCardList[2]["desc"] = "Missing Jars: ${decodedJson["data"]["home"]["missingJars"]}";
          topCardList[2]["misc"] = "Total Jars: ${decodedJson["data"]["home"]["totalJars"]}";
          topCardList[3]["desc"] = "Total Drivers: ${decodedJson["data"]["home"]["drivers"]["total"]}";
          vendorName = decodedJson["data"]["home"]["vendorName"];
          driverList = formatted;
          isLoading = false;
        });

      } else {
        await FirebaseAuth.instance.signOut();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove('vendorId');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
      }

    }
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Spinner();
    }


    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Stats'),
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
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          color: Color(0xFF4267B2),
          child: Column(
            children: [
              Container(
                height: 128,
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("https://unsplash.com/photos/Y7C7F26fzZM/download?force=true&w=640"),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(width: 2.0,color: Colors.white)
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $vendorName",
                          style: nameTextStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Welcome to Waterkard",
                          style: subTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      )),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 32, left: 32),
                          child: Text(
                            "Navigation",
                            style: titleTextStyle,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 232,
                          margin: EdgeInsets.only(top: 16),
                          child: PageView(
                            controller: PageController(viewportFraction: 0.8,initialPage: 2),
                            children:topCardList.map((e) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => ListAllDrivers()));
                                },

                                child: SingleCard(
                                  color: e["color"],
                                  misc: e["misc"],
                                  page: e["page"],
                                  title: e["title"],
                                  desc: e["desc"],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 32, left: 32),
                          child: Text(
                            "Drivers",
                            style: titleTextStyle,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        sliver: SliverGrid.count(
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 16,
                          childAspectRatio: .95,
                          crossAxisCount: 2,
                          children: driverList.map((e) {
                            return DriverCard(
                              color: e["color"],
                              name: e["name"],
                              jars: e["jars"],
                              title: e["title"],
                              image: e["image"],
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



class SingleCard extends StatelessWidget {
  final Color color;
  final String title;
  final String desc;
  final String misc;
  final String page;

  const SingleCard({Key key, this.color, this.title, this.desc, this.misc, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8
            )
          ]),
      child: Container(
        margin: EdgeInsets.only(left: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 39,
              width: 40,
              margin: EdgeInsets.only(top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    page,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(title,
              style: cardNameTextStyle,),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  // Hero(
                  //   tag:image,
                  //   child: Container(
                  //     height: 72,
                  //     width: 72,
                  //     decoration: BoxDecoration(
                  //         image: DecorationImage(
                  //             image: NetworkImage(image),
                  //             fit: BoxFit.cover
                  //         ),
                  //         borderRadius: BorderRadius.circular(36),
                  //         border: Border.all(width: 3.0,color: Colors.white)
                  //     ),
                  //   ),
                  // ),
                  Container(
                    // margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(desc, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 18),),
                        SizedBox(height: 8,),
                        Text(misc, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),)
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class DriverCard extends StatelessWidget {
  final Color color;
  final String title;
  final String image;
  final String name;
  final String jars;
  const DriverCard({Key key, @required this.color, this.title, this.image, this.name, this.jars}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2),spreadRadius: 1,blurRadius: 8)
          ]
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(width: 3.0,color: Colors.white)
                  ),
                ),
                SizedBox(width: 8,),
                Flexible(child: Text(name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),))
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                         jars,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),

                  Text(
                    title,
                    style: subTitleTextStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
