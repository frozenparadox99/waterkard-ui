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

class EditVendor extends StatefulWidget {
  const EditVendor({Key key}) : super(key: key);

  @override
  _EditVendorState createState() => _EditVendorState();
}

class _EditVendorState extends State<EditVendor> {
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

  String fullVendorName="";
  String fullBusinessName="";
  String brandName="";

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
          "$API_BASE_URL/api/v1/vendor/id?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["vendor"]!=null){
        var receivedGroups = decodedJson["data"]["vendor"];
        setState(() {
          fullVendorName = receivedGroups["fullVendorName"];
          fullBusinessName = receivedGroups["fullBusinessName"];
          brandName = receivedGroups["brandName"];
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
          title: Text('Vendor'),
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
                        label: '$fullVendorName',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[

                        CardSettingsText(
                          icon: Icon(Icons.person_add_alt_1),
                          label: 'Name',
                          hintText: '$fullVendorName',
                          key: _nameKey,
                          onChanged: (value) {
                            setState(() {
                              fullVendorName = value;
                            });
                          },
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.person_pin),
                          key: _emailKey,
                          label: "Business Name",
                          hintText: '$fullBusinessName',
                          onChanged: (value) {
                            setState(() {
                              fullBusinessName = value;
                            });
                          },
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.branding_watermark),
                          label: 'Brand Name',
                          hintText: '$brandName',
                          key: _pincodeKey,
                          onChanged: (value) {
                            setState(() {
                              brandName = value;
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
                                    "$API_BASE_URL/api/v1/vendor";
                                var response = await http.patch(Uri.parse(apiURL),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body:jsonEncode( <String, dynamic>{
                                      "vendor":id,
                                      "fullBusinessName":fullBusinessName,
                                      "fullVendorName":fullVendorName,
                                      "brandName":brandName,
                                    }));
                                var body = response.body;

                                var decodedJson = jsonDecode(body);

                                print(body);
                                print(decodedJson);

                                if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => EditVendor()));
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
                                                    context, MaterialPageRoute(builder: (context) => EditVendor()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => EditVendor()));
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
                                                    context, MaterialPageRoute(builder: (context) => EditVendor()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => EditVendor()));
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
