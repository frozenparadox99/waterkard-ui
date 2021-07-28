import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/add_payment.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_previous_payments.dart';
import 'package:waterkard/ui/pages/my_products_pages/edit_product.dart';


import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/Spinner.dart';

class TransactionModel {
  String name;

  String deposit18;

  String deposit20;



  TransactionModel(this.name, this.deposit18,
      this.deposit20,);
}


class CustomerPaymentList extends StatefulWidget {
  const CustomerPaymentList({Key key}) : super(key: key);

  @override
  _CustomerPaymentListState createState() => _CustomerPaymentListState();
}

class _CustomerPaymentListState extends State<CustomerPaymentList> {

  String uid;

  String currentStateSelected;
  bool isLoading = false;
  List<TransactionModel> allCustomersForVendor = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllCustomerDeposits();
  }

  void getAllCustomerDeposits () async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/customer/deposits?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customers"]!=null){
        List<dynamic> receivedCustomers = decodedJson["data"]["customers"];
        List<dynamic> formatted = receivedCustomers.map((e) => {
          "name":e["name"],
          "deposit18": e["products"].length==1?e["products"][0]["product"]=="18L"?e["products"][0]["deposit"]:0:e["products"][0]["deposit"],
          "deposit20": e["products"].length==1?e["products"][0]["product"]=="20L"?e["products"][0]["deposit"]:0:e["products"][1]["deposit"],
        }).toList();



        setState(() {
          allCustomersForVendor = formatted.map((item) => TransactionModel(
            item['name'],
            "${item['deposit18']}",
              "${item['deposit20']}"
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
                        context, MaterialPageRoute(builder: (context) => AddPayment()));
            },
          ),
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


                              ...allCustomersForVendor.map((e) =>
                                  DepositContainer(e.name,e.deposit18,e.deposit20)
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

  Column _iconBuilder(icon, title) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 28,
          color: Colors.indigo[400],
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class DepositContainer extends StatelessWidget {
  String name;
  String deposit18;
  String deposit20;

  DepositContainer(this.name, this.deposit18,this.deposit20) ;

  @override
  Widget build(BuildContext context) {
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
                  text: '$name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\nAdvance 18L: Rs.$deposit18',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    TextSpan(
                      text: '\nAdvance 20L: Rs.$deposit20',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Icon(
              //     Icons.arrow_forward_ios,
              //     color: Colors.grey[400],
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),

          // Divider(
          //   color: Colors.grey[200],
          //   height: 3,
          //   thickness: 1,
          // ),
          // SizedBox(
          //   height: 8.0,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: <Widget>[
          //     _iconBuilder(Icons.add_circle, 'Add Payment'),
          //     _iconBuilder(Icons.notifications, 'Request'),
          //     InkWell(onTap: (){
          //       Navigator.pushReplacement(
          //           context, MaterialPageRoute(builder: (context) => CustomerPreviousPayments()));
          //     }
          //         ,child: _iconBuilder(Icons.edit, 'Edit')),
          //     _iconBuilder(Icons.cancel, 'Delete'),
          //
          //   ],
          // )
        ],
      ),
    );
  }
}
