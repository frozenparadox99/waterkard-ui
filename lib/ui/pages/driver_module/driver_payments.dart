import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/driver_module/customer_to_driver_payment.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/add_driver_payment.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/driver_previous_payments.dart';



import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/Spinner.dart';

class TransactionModel {
  String name;

  int given;

  int received;

  int today;



  TransactionModel(this.name, this.given,
      this.received,this.today);
}


class DriversPayments extends StatefulWidget {
  const DriversPayments({Key key}) : super(key: key);

  @override
  _DriversPaymentsState createState() => _DriversPaymentsState();
}

class _DriversPaymentsState extends State<DriversPayments> {

  String uid;

  String currentStateSelected;
  bool isLoading = false;

  List<TransactionModel> allDriversForVendor = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    // uid = FirebaseAuth.instance.currentUser.uid;

    getAllDriverData();
  }

  void getAllDriverData () async {
    setState(() {
      isLoading = true;
    });


    var response = await http.get(ApiEndPoints.driversPayments);
    var body = response.body;

    var decodedJson = jsonDecode(body);

    print(body);
    print(decodedJson);
    if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["payments"]!=null){
      List<dynamic> receivedCustomers = decodedJson["data"]["payments"];
      List<dynamic> formatted = receivedCustomers.map((e) => {
        "name":e["name"],
        "received":e["received"],
        "given":e["given"],
        "today":e["today"],
      }).toList();



      setState(() {
        allDriversForVendor = formatted.map((item) => TransactionModel(
            item['name'],
            item['given'],
            item['received'],
            item['today']
        ))
            .toList();
        isLoading = false;
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Spinner();
    }
    return  Scaffold(
      drawer: SidebarDriver(),
      appBar: AppBar(
        title: Text('Payment'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => CustomerToDriverPayment()));
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
        width: double.infinity,
        decoration: BoxDecoration(

          color: Color(0xFF4267B2),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("Driver Payment", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("List of Drivers", style: TextStyle(color: Colors.white, fontSize: 18),),
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

                        SizedBox(height: 30,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[


                              ...allDriversForVendor.map((e) =>
                                  _paymentBuilder(e.name,e.today,e.received,e.given)
                              ).toList(),



                            ],
                          ),
                        ),
                        SizedBox(height: 40,),


                        SizedBox(height: 10,),


                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
                        SizedBox(height: 40,),
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


  Container _paymentBuilder(driverName,today,received,given){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
                backgroundImage: AssetImage("assets/profile_user.jpg"),
                radius: 28.0,
              ),
              SizedBox(width: 10,),
              RichText(
                text: TextSpan(
                  text: '$driverName',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),

                ),
              ),


            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            color: Colors.grey[200],
            height: 3,
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _iconBuilder("Today's\nCollection", '$today'),
                _iconBuilder("Received\nCollection", '$received'),
                _iconBuilder("Given\nCollection", '$given'),
                _iconBuilder("Balance\nCollection", '${received - given}'),

              ],
            ),
          )
        ],
      ),
    );
  }

  Container _iconBuilder(heading, title) {
    return Container(
      // decoration: BoxDecoration(
      //     border: Border(
      //       left: BorderSide(color: Colors.grey),
      //       right: BorderSide(color: Colors.grey),
      //     ),
      // ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            heading,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "Rs.$title",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}