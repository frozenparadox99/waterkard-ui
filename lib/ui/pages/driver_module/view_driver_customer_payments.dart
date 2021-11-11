import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/whatsapp_service.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/add_payment.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_previous_payments.dart';
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

import '../../../utils.dart';
import 'customer_to_driver_payment.dart';

class TransactionModel {
  String name;

  String deposit18;

  String deposit20;

  String customer;

  String mobileNumber;

  TransactionModel(this.name, this.deposit18,
      this.deposit20, this.customer,this.mobileNumber);
}


class ViewDriverCustomerPayments extends StatefulWidget {
  const ViewDriverCustomerPayments({Key key}) : super(key: key);

  @override
  _ViewDriverCustomerPaymentsState createState() => _ViewDriverCustomerPaymentsState();
}

class _ViewDriverCustomerPaymentsState extends State<ViewDriverCustomerPayments> {

  // String uid;

  String currentStateSelected;
  bool isLoading = false;
  String total18="";
  String total20="";

  List<TransactionModel> allCustomersForVendor = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    // uid = FirebaseAuth.instance.currentUser.uid;

    getAllCustomerDeposits();
  }

  void getAllCustomerDeposits () async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("driverVendor");
    var driverId = prefs.getString("driverId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/customer/all-payments?vendor=$id&driver=$driverId";
      print(apiURL);
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customers"]!=null){
        List<dynamic> receivedCustomers = decodedJson["data"]["customers"];
        List<dynamic> formatted = receivedCustomers.map((e) => {
          "name":e["name"],
          "customer":e["_id"],
          "balancePayment": e["balancePayment"],
          "mobileNumber":e["mobileNumber"]
        }).toList();



        setState(() {
          allCustomersForVendor = formatted.map((item) => TransactionModel(
              item['name'],
              "${item['balancePayment']}",
              "${item['balancePayment']}",
              item["customer"],
              "${item["mobileNumber"]}"
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
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () async {
          //     await FirebaseAuth.instance.signOut();
          //     Navigator.pushReplacement(
          //         context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
          //   },
          // )
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
                    child: Text("Customer Payment", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("List of Customers", style: TextStyle(color: Colors.white, fontSize: 18),),
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


                              ...allCustomersForVendor.map((e) =>
                                  _newPaymentBuilder(e.name,e.deposit18,e.deposit20,e.mobileNumber,e.customer)
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

  InkWell _newPaymentBuilder(customerName,adv18,adv20,phoneNumber,customer){
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
            context, MaterialPageRoute(builder: (context) => CustomerPreviousPayments( customer,customerName)));
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
                            customerName,
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
                  // InkWell(
                  //   onTap: (){
                  //     Navigator.pushReplacement(
                  //         context, MaterialPageRoute(builder: (context) => CustomerPreviousPayments(customer,customerName)));
                  //   },
                  //   child: Icon(
                  //     Icons.view_list_rounded,
                  //     color: colorLightBlue,
                  //     size: 30,
                  //   ),
                  // ),
                  Text(
                    int.parse("$adv18")>0?"Balance:":"Advance:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Text(
                    int.parse("$adv18")>0?" $adv18":" ${int.parse("$adv18")*-1}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: int.parse("$adv18")>0?Colors.red:Colors.green,
                    ),
                  ),
                  // SizedBox(width: 5,),
                  // InkWell(
                  //   onTap: (){
                  //     Navigator.pushReplacement(
                  //         context, MaterialPageRoute(builder: (context) => CustomerToDriverPayment()));
                  //   },
                  //   child: Icon(
                  //     Icons.add_circle,
                  //     color: colorLightBlue,
                  //     size: 30,
                  //   ),
                  // ),
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
                        'Add',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: ()  {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => CustomerToDriverPayment()));
                        },
                      ),
                    ],
                  ),
                  // VerticalDivider(
                  //   color: Colors.black,
                  //   thickness: 1,
                  //   width: 1,
                  // ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "Advance 20L",
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //           fontSize: 17,
                  //           fontWeight: FontWeight.bold
                  //       ),
                  //     ),
                  //     Text(
                  //       '$adv20',
                  //       style: TextStyle(
                  //           fontSize: 17,
                  //           fontWeight: FontWeight.bold
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Request',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.money),
                        onPressed: ()  {
                          WhatsAppService().toContact(
                            contactNumber: phoneNumber.split("+91")[1],
                            message: "Your outstanding payment for 18L jars is $adv18 and for 20l jars is $adv20",
                          );
                        },
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
