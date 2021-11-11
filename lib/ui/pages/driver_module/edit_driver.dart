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
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

class EditDriverPage extends StatefulWidget {
  const EditDriverPage({Key key}) : super(key: key);

  @override
  _EditDriverPageState createState() => _EditDriverPageState();
}

class _EditDriverPageState extends State<EditDriverPage> {
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
  String password="";


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
    var id = prefs.getString("driverId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/driver/getDriverDetails?driverId=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["driver"]!=null){
        var receivedGroups = decodedJson["data"]["driver"];
        setState(() {
          name = receivedGroups["name"];
          password = receivedGroups["password"];
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: SidebarDriver(),
        appBar: AppBar(
          title: Text('Driver'),
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
                          icon: Icon(Icons.security_rounded),
                          key: _emailKey,
                          label: "Password",
                          hintText: '$password',
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                        ),





                        CardSettingsButton(

                          onPressed: () async {
                            if(_formKey.currentState.validate()){




                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              var id = prefs.getString("driverId");
                              print(id);

                              if(id!=null){

                                String apiURL =
                                    "$API_BASE_URL/api/v1/vendor/driver";
                                var response = await http.patch(Uri.parse(apiURL),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body:jsonEncode( <String, dynamic>{
                                      "driver":id,
                                      "name":name,
                                      "password":password,
                                    }));
                                var body = response.body;

                                var decodedJson = jsonDecode(body);

                                print(body);
                                print(decodedJson);

                                if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                  Navigator.pushReplacement(
                                      context, MaterialPageRoute(builder: (context) => EditDriverPage()));
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
                                                    context, MaterialPageRoute(builder: (context) => EditDriverPage()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => EditDriverPage()));
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
                                                    context, MaterialPageRoute(builder: (context) => EditDriverPage()));
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ).then((value) {
                                    if(value!=null && value=="closePage"){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => EditDriverPage()));
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
