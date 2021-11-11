import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/my_customers/customer_list.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

class EditCustomer extends StatefulWidget {
  String customerId;


  EditCustomer(this.customerId);

  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _pincodeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _areaKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
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

  String name = "";
  String email="";


  String area="";
  String pincode="";

  List<dynamic> allCustomerNames = <String>[];
  List<dynamic> allCustomerIds = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getCustomerData();
  }

  void getCustomerData () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/customer/id?vendor=$id&customer=${widget.customerId}";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customer"]!=null){
        var receivedGroups = decodedJson["data"]["customer"];
        setState(() {
          name = receivedGroups["name"];
          email = receivedGroups["email"];
          area = receivedGroups["area"];
          pincode = receivedGroups["pincode"];
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
          title: Text('Customers'),
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
                        label: '$name',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[

                        CardSettingsText(
                          icon: Icon(Icons.person_add_alt_1),
                          label: 'Name',
                          hintText: '$name',
                          key: _nameKey,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.mail_outline),
                          key: _emailKey,
                          label: "Email",
                          hintText: '$email',
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.person_pin_circle),
                          label: 'Pincode',
                          hintText: '$pincode',
                          key: _pincodeKey,
                          onChanged: (value) {
                            setState(() {
                              pincode = value;
                            });
                          },
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.location_city_sharp),
                          label: 'Area',
                          hintText: '$area',

                          key: _areaKey,
                          onChanged: (value) {
                            setState(() {
                              area = value;
                            });
                          },
                        ),



                        CardSettingsButton(

                          onPressed: () async {
                            if(_formKey.currentState.validate()){




                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var id = prefs.getString("vendorId");
                              print(id);

                              if(id!=null){

                                String apiURL =
                                    "$API_BASE_URL/api/v1/vendor/customer";
                                var response = await http.patch(Uri.parse(apiURL),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body:jsonEncode( <String, dynamic>{
                                      "id":widget.customerId,
                                      "name":name,
                                      "email":productType,
                                      "area":customerSelected,
                                      "pincode":paymentMethod,
                                    }));
                                var body = response.body;

                                var decodedJson = jsonDecode(body);

                                print(body);
                                print(decodedJson);

                                if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => CustomerListDsisplay()));
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
                                                    context, MaterialPageRoute(builder: (context) => CustomerListDsisplay()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => CustomerListDsisplay()));
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
                                                    context, MaterialPageRoute(builder: (context) => CustomerListDsisplay()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => CustomerListDsisplay()));
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
                                context, MaterialPageRoute(builder: (context) => CustomerListDsisplay()));
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
