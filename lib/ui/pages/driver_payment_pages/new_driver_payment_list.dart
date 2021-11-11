import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/add_driver_payment.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/driver_previous_payments.dart';



import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/Spinner.dart';

import '../../../utils.dart';

class TransactionModel {
  String name;

  int given;

  int received;

  int today;

  String driverId;

  TransactionModel(this.name, this.given,
      this.received,this.today,this.driverId);
}


class NewDriverPaymentList extends StatefulWidget {
  const NewDriverPaymentList({Key key}) : super(key: key);

  @override
  _NewDriverPaymentListState createState() => _NewDriverPaymentListState();
}

class _NewDriverPaymentListState extends State<NewDriverPaymentList> {

  String uid;

  String currentStateSelected;
  bool isLoading = false;

  List<TransactionModel> allDriversForVendor = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;

    getAllDriverData();
  }

  void getAllDriverData () async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/driver/payments?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
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
          "driverId":e["_id"]
        }).toList();



        setState(() {
          allDriversForVendor = formatted.map((item) => TransactionModel(
              item['name'],
              item['given'],
              item['received'],
              item['today'],
              item['driverId']
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
    return  Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Payment'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddDriverPayment()));
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
              padding: EdgeInsets.all(30),
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
                      // borderRadius: BorderRadius.only(
                      //   topLeft: Radius.circular(60),
                      //   topRight: Radius.circular(60),
                      // )
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[

                        SizedBox(height: 5,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[


                              ...allDriversForVendor.map((e) =>
                                  _newPaymentBuilder(e.name,e.today,e.received,e.given,e.driverId)
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

  InkWell _newPaymentBuilder(driverName,today,received,given,driverId){
    return InkWell(
      // onDoubleTap: (){
      //   print(customerMap["_id"]);
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context)=>DailyTransactionList(customerId: customerMap["_id"]))
      //   );
      // },
      onTap: (){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DriverPreviousPayments(driverId, driverName)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: colorLightBlue,
                  blurRadius: 10,
                  spreadRadius: 2
              )
            ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: Row(
                children: [
                  // IconButton(
                  //     icon: Icon(
                  //       Icons.call_sharp,
                  //       color: colorLightBlue,
                  //       size: 30,
                  //     ),
                  //     onPressed: (){
                  //       print(customerMap);
                  //       call(customerMap["mobileNumber"]);
                  //     }
                  // ),
                  SizedBox(width: 10,),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driverName,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          // Text(
                          //   customerMap["group"],
                          //   style: TextStyle(
                          //       fontSize: 15,
                          //       fontWeight: FontWeight.bold,
                          //       color: colorLightBlue
                          //   ),
                          // ),
                        ],
                      )
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => DriverPreviousPayments(driverId, driverName)));
                    },
                    child: Icon(
                      Icons.view_list_rounded,
                      color: colorLightBlue,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => AddDriverPayment()));
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: colorLightBlue,
                      size: 30,
                    ),
                  ),
                  // SizedBox(width: 5,),
                  // InkWell(
                  //   onTap: (){
                  //
                  //   },
                  //   child: Container(
                  //     height: 27,
                  //     width: 27,
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(color: Colors.red, width: 3)
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
              height: 1,
            ),
            SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Today's\nCollection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '$today',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Received\nCollection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '$received',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Given\nCollection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '$given',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Balance\nCollection",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        '${received - given}',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  InkWell _paymentBuilder(driverName,today,received,given,driverId){
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DriverPreviousPayments(driverId, driverName)));
      },
      child: Container(
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
