import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/new_customer_payment_list.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _customerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _paymentMethodKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _amountKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productTypeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chequeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _onlineAppKey = GlobalKey<FormState>();
  String uid;
  String paymentMethod="Cash";
  DateTime date = DateTime.now();
  String customerSelected="";
  String productType = "";
  String amount = "0";
  String onlineApp = "None";
  String chequeNumber = "None";

  List<dynamic> allCustomerNames = <String>[];
  List<dynamic> allCustomerIds = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllCustomers();
  }

  void getAllCustomers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/customer?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customers"]!=null){
        List<dynamic> receivedGroups = decodedJson["data"]["customers"];
        receivedGroups.forEach((ele) {

          setState(() {
            allCustomerNames.add(ele["name"]);
            allCustomerIds.add(ele["_id"]);
          });
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Sidebar(),
        appBar: AppBar(
          title: Text('My Products'),
          actions: [
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 50.0,),
              Form(
                key: _formKey,
                child: CardSettings(

                  contentAlign: TextAlign.right,
                  children: <CardSettingsSection>[
                    CardSettingsSection(
                      header: CardSettingsHeader(
                        label: 'Add Payment',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[

                        CardSettingsListPicker(
                          icon: Icon(Icons.group),
                          key: _customerKey,
                          label: 'Customers',
                          initialValue: 'Default',
                          hintText: 'Select Customer',
                          options: allCustomerNames,
                          values: allCustomerIds,
                          onChanged: (value) async{

                            setState(() {
                              customerSelected = value;
                            });
                          },
                        ),
                        CardSettingsListPicker(
                          icon: Icon(Icons.shopping_cart_outlined),
                          key: _productTypeKey,
                          label: 'Product',
                          initialValue: '18 Litre Jar',
                          hintText: 'Select Jar',
                          options: <String>['18 L Jar', '20 L Jar'],
                          values: <String>['18L', '20L'],
                          onChanged: (value) {
                            setState(() {
                              productType = value;
                            });
                          },
                        ),
                        CardSettingsDatePicker(
                          key: _dateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime.now(),
                          onChanged: (value) {
                            setState(() {
                              date = value;
                            });
                          },

                        ),
                        CardSettingsText(
                          key: _amountKey,
                          icon: Icon(Icons.money),
                          label: 'Amount',
                          hintText: 'Enter Amount Here',
                          onChanged: (value) {
                            setState(() {
                              amount = value;
                            });
                          },
                        ),

                        CardSettingsListPicker(
                          icon: Icon(Icons.credit_card_sharp),
                          key: _paymentMethodKey,
                          label: 'Payment',
                          initialValue: 'Cash',
                          hintText: 'Select Method',
                          options: <String>['Cash', 'Online', 'Cheque'],
                          values: <String>['Cash', 'Online','Cheque'],
                          onChanged: (value){
                            setState(() {
                              paymentMethod = value;
                            });
                          },
                        ),

                        paymentMethod == "cash"?CardSettingsText(

                          icon: Icon(Icons.money),
                          label: 'Note',
                          hintText: 'Enter Additional Info',

                        ): paymentMethod=="online"?CardSettingsText(
                          icon: Icon(Icons.send_to_mobile),
                          key: _onlineAppKey,
                          label: 'App',
                          hintText: 'Enter App Name',
                          onChanged: (value){
                            setState(() {
                              onlineApp = value;
                            });
                          },
                        ): paymentMethod=="cheque"?CardSettingsText(
                          icon: Icon(Icons.money),
                          key: _chequeKey,
                          label: 'Cheque',
                          hintText: 'Enter Cheque Number',
                          onChanged: (value){
                            setState(() {
                              chequeNumber = value;
                            });
                          },
                        ):CardSettingsText(

                          icon: Icon(Icons.money),
                          label: 'Note',
                          hintText: 'Enter Additional Info',

                        ),



                        CardSettingsButton(

                          onPressed: () async {
                            if(_formKey.currentState.validate()){

                              print(date);
                              print(amount);
                              print(customerSelected);
                              print(paymentMethod);
                              print(productType);
                              print(chequeNumber);
                              print(onlineApp);
                              print(date.day);
                              print(date.month);
                              print(date.year);

                              String newDate = "${date.day}/${date.month}/${date.year}";


                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var id = prefs.getString("vendorId");
                              print(id);

                              if(id!=null){

                                String apiURL =
                                    "$API_BASE_URL/api/v1/vendor/customer/payment";
                                var response = await http.post(Uri.parse(apiURL),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body:jsonEncode( <String, dynamic>{
                                      "vendor":id,
                                      "date":newDate,
                                      "product":productType,
                                      "customer":customerSelected,
                                      "mode":paymentMethod,
                                      "amount":amount,
                                      "chequeDetails":chequeNumber,
                                      "onlineAppForPayment":onlineApp,
                                      "from":"Customer",
                                      "to":"Vendor"
                                    }));
                                var body = response.body;

                                var decodedJson = jsonDecode(body);

                                print(body);
                                print(decodedJson);

                                if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => NewCustomerPaymentList()));
                                }
                                else if (decodedJson["success"]!=null && decodedJson["success"]==false && decodedJson["message"]!=null){
                                  successMessageDialogue(
                                    context: context,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.blue,
                                            size: 100,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(decodedJson['message'],
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            MaterialButton(
                                              child: Text(
                                                "Back",
                                                style: TextStyle(
                                                    fontSize: 18
                                                ),
                                              ),
                                              onPressed: (){
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(builder: (context) => NewCustomerPaymentList()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => NewCustomerPaymentList()));
                                    }
                                  });
                                }
                                else if (decodedJson["success"]!=null && decodedJson["success"]==false){
                                  successMessageDialogue(
                                    context: context,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.blue,
                                            size: 100,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        ...getErrorWidget(decodedJson["errors"]),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            MaterialButton(
                                              child: Text(
                                                "Back",
                                                style: TextStyle(
                                                    fontSize: 18
                                                ),
                                              ),
                                              onPressed: (){
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(builder: (context) => NewCustomerPaymentList()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => NewCustomerPaymentList()));
                                    }
                                  });
                                }

                              }


                            }

                          },

                          label: 'SAVE',
                          backgroundColor: Color(0xFF80D8FF),
                        ),

                        CardSettingsButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => NewCustomerPaymentList()));
                          },
                          label: 'CANCEL',
                          isDestructive: true,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          bottomSpacing: 4.0,
                        ),


                      ],
                    ),
                    // CardSettingsSection(
                    //
                    //   header: CardSettingsHeader(
                    //     label: 'Actions',
                    //   ),
                    //   children: <CardSettingsWidget>[
                    //     CardSettingsButton(
                    //
                    //       label: 'SAVE',
                    //       backgroundColor: Color(0xFF80D8FF),
                    //     ),
                    //     CardSettingsButton(
                    //       label: 'CANCEL',
                    //       isDestructive: true,
                    //       backgroundColor: Colors.red,
                    //       textColor: Colors.white,
                    //       bottomSpacing: 4.0,
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),

              SizedBox(height: 20.0,),


            ],
          ),
        ),
      ),
    );
  }


}
