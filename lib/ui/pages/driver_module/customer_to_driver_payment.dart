import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/driver_module/driver_payments.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/driver_payment_list.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

class CustomerToDriverPayment extends StatefulWidget {
  const CustomerToDriverPayment({Key key}) : super(key: key);

  @override
  _CustomerToDriverPaymentState createState() => _CustomerToDriverPaymentState();
}

class _CustomerToDriverPaymentState extends State<CustomerToDriverPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _driverKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _paymentMethodKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _amountKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _chequeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _onlineAppKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productKey = GlobalKey<FormState>();
  // String uid;
  String paymentMethod="Cash";
  DateTime date = DateTime.now();
  String driverSelected="";
  String productSelected = "18L";
  String amount = "0";
  String onlineApp = "None";
  String chequeNumber = "None";

  List<dynamic> allDriverNames = <String>[];
  List<dynamic> allDriverIds = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // uid = FirebaseAuth.instance.currentUser.uid;
    getDriversCustomers();
  }

  void getDriversCustomers () async {



      String apiURL =
          "$API_BASE_URL/api/v1/driver/customers/details?driver=${SharedPrefsService.getDriverId()}";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customers"]!=null){
        List<dynamic> receivedGroups = decodedJson["data"]["customers"];
        receivedGroups.forEach((ele) {

          setState(() {
            allDriverNames.add(ele["name"]);
            allDriverIds.add(ele["_id"]);
          });
        });
      }


  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SidebarDriver(),
        appBar: AppBar(
          title: Text('Payment'),
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
              onPressed: ()  {
                // await FirebaseAuth.instance.signOut();
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
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
                          key: _driverKey,
                          label: 'Customer',
                          initialValue: 'Default',
                          hintText: 'Select Customer',
                          options: allDriverNames,
                          values: allDriverIds,
                          onChanged: (value) async{

                            setState(() {
                              driverSelected = value;
                            });
                          },
                        ),

                        CardSettingsListPicker(
                          icon: Icon(Icons.shop),
                          key: _productKey,
                          label: 'Product',
                          initialValue: '18L',
                          hintText: 'Select Product',
                          options: ['18L','20L'],
                          values: ['18L','20L'],
                          onChanged: (value) async{

                            setState(() {
                              productSelected = value;
                            });
                          },
                        ),

                        CardSettingsDatePicker(
                          key: _dateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime(2021, 10, 10, 20, 30),
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

                              print(paymentMethod);
                              print(driverSelected);

                              print(chequeNumber);
                              print(onlineApp);
                              print(date.day);
                              print(date.month);
                              print(date.year);

                              String newDate = "${date.day}/${date.month}/${date.year}";






                                String apiURL =
                                    "$API_BASE_URL/api/v1/vendor/driver/payment";
                                var response = await http.post(Uri.parse(apiURL),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body:jsonEncode( <String, dynamic>{
                                      "vendor":SharedPrefsService.getDriverVendor(),
                                      "date":newDate,
                                      "product":productSelected,
                                      "to":"Driver",
                                      "from":"Customer",
                                      "customer":driverSelected,
                                      "driver":SharedPrefsService.getDriverId(),
                                      "mode":paymentMethod,
                                      "amount":amount,
                                      "chequeDetails":chequeNumber,
                                      "onlineAppForPayment":onlineApp
                                    }));
                                var body = response.body;

                                var decodedJson = jsonDecode(body);

                                print(body);
                                print(decodedJson);

                                if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => DriversPayments()));
                                } else if (decodedJson["success"]!=null && decodedJson["success"]==false && decodedJson["message"]!=null){
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
                                                    context, MaterialPageRoute(builder: (context) => DriversPayments()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => DriversPayments()));
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
                                                    context, MaterialPageRoute(builder: (context) => DriversPayments()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => DriversPayments()));
                                    }
                                  });
                                }




                            }

                          },

                          label: 'SAVE',
                          backgroundColor: Color(0xFF80D8FF),
                        ),

                        CardSettingsButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => DriversPayments()));
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
