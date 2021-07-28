import 'package:flutter/material.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/vendor_home_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:waterkard/ui/widgets/Spinner.dart';

TextStyle headingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700
);
TextStyle contentStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'sfpro'
);
LinearGradient gradientStyle = LinearGradient(
    colors: [Color(0xfff3953b), Color(0xffe57509)],
    stops: [0,1],
    begin: Alignment.topCenter
);

class TrackingJars extends StatefulWidget {

  String driverId;
  String driverName;
  String group;

  TrackingJars(this.driverId,this.driverName,this.group);

  @override
  _TrackingJarsState createState() => _TrackingJarsState();
}

class _TrackingJarsState extends State<TrackingJars> {

  bool isLoading = false;
  String stage1Load = "0";
  String stage2Expected = "0";
  String stage3Unload = "0";
  String stage4Missing = "0";
  bool stage2Present = false;
  bool stage3Present = false;
  bool stage4Present = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDisplayData();
  }

  void getDisplayData () async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      DateTime now = new DateTime.now();
      String newDate = "${now.day}/${now.month}/${now.year}";
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/inventory/daily-status?vendor=$id&date=$newDate&driver=${widget.driverId}";
      print((apiURL));
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);


      if(decodedJson["success"]!=null && decodedJson["success"] == true ){
        setState(() {
          stage1Load = "${decodedJson["data"]["stage1"]}";
          if(decodedJson["data"]["stage2"]["present"]){
            stage2Present = true;
            stage2Expected = "${decodedJson["data"]["stage2"]["empty"]+decodedJson["data"]["stage2"]["filled"]}";
          }
          if(decodedJson["data"]["stage3"]["present"]){
            stage3Present = true;
            stage3Unload = "${decodedJson["data"]["stage3"]["empty"]+decodedJson["data"]["stage3"]["filled"]}";
          }
          if(decodedJson["data"]["stage4"]["present"]){
            stage4Present = true;
            stage4Missing = "${decodedJson["data"]["stage4"]["empty"]+decodedJson["data"]["stage4"]["filled"]}";
          }
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
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Missing Jars'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add_circle),
          //   onPressed: ()  {
          //     // Navigator.pushReplacement(
          //     //     context, MaterialPageRoute(builder: (context) => AddProduct()));
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Group: ${widget.group}", style: headingStyle,),
              Text("Driver Assigned: ${widget.driverName}", style: contentStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 16
              ),),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 1,
                color: Colors.grey,
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 13, top: 50),
                    width: 4,
                    height: 400,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      statusWidget('shipped', "Confirmed ", true),
                      statusWidget('onBoard2', "Loaded Jars: $stage1Load", true),
                      statusWidget('shipped', "Expected Jars: $stage2Expected", stage2Present),
                      statusWidget('servicesImg', "Unloaded Jars: $stage3Unload", stage3Present),
                      statusWidget('shipped', "Missing Jars: $stage4Missing", stage4Present),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 1,
                color: Colors.grey,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => VendorHomePage()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: Color(0xFF5F6AF8),
                          )
                      ),
                      child: Text("Back", style: contentStyle.copyWith(
                        color: Color(0xFF5F6AF8),
                      ),),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //
                  //     color: Color(0xFF5F6AF8),
                  //
                  //   ),
                  //   child: Text("View Order", style: contentStyle.copyWith(
                  //       color: Colors.white
                  //   ),),
                  // ),
                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
  Container statusWidget(String img, String status, bool isActive)
  {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,

            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive) ? Color(0xFF5F6AF8) : Colors.white,
                border: Border.all(
                    color: (isActive) ? Colors.transparent : Color(0xFF5F6AF8),
                    width: 3
                )
            ),
          ),
          SizedBox(width: 50,),
          Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/$img.png"),
                        fit: BoxFit.contain
                    )
                ),
              ),

            ],
          ),
          SizedBox(width: 50,),
          Text(status, style: contentStyle.copyWith(
              color: (isActive) ? Color(0xFF5F6AF8) : Colors.black
          ),)
        ],
      ),
    );
  }
}