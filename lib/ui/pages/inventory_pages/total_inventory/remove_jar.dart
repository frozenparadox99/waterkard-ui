import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/total_inventory_add.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/total_inventory_remove.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';


class RemoveJar extends StatefulWidget {
  const RemoveJar({Key key}) : super(key: key);

  @override
  _RemoveJarState createState() => _RemoveJarState();
}

class _RemoveJarState extends State<RemoveJar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _groupKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customersKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _coolJarKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bottleJarKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  String uid;

  var allGroupNames = <String>[];
  var allGroupIds = <String>[];

  List<dynamic> allCustomerNames = <String>[];
  List<dynamic> allCustomerIds = <String>[];

  List<String> customerProductNames = <String>[];
  List<String> customerProductIds = <String>[];

  String customerSelected="";
  String productSelected="";
  String coolJarQty = "";
  String bottleJarQty = "";
  DateTime date = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add_circle),
          //   onPressed: ()  {},
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
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: CardSettings(

          contentAlign: TextAlign.right,
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Remove Inventory',
                labelAlign: TextAlign.center,
              ),
              children: <CardSettingsWidget>[
                CardSettingsDatePicker(
                  key: _dateKey,
                  icon: Icon(Icons.calendar_today),
                  label: 'Date',
                  dateFormat: DateFormat.yMMMMd(),
                  initialValue:  DateTime(2020, 10, 10, 20, 30),
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },

                ),
                CardSettingsText(
                  icon: Icon(Icons.store),
                  label: 'Cool Jar Stock',
                  hintText: 'Enter Jar Quantity',
                  key: _coolJarKey,
                  onChanged: (value) {
                    setState(() {
                      coolJarQty = value;
                    });
                  },
                ),

                CardSettingsText(
                  icon: Icon(Icons.storefront),
                  label: 'Bottle Jar Stock',
                  hintText: 'Enter Jar Quantity',
                  key: _bottleJarKey,
                  onChanged: (value) {
                    setState(() {
                      bottleJarQty = value;
                    });
                  },
                ),






                CardSettingsButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){

                      print(date);
                      print(coolJarQty);
                      print(bottleJarQty);
                      print(date.day);
                      print(date.month);
                      print(date.year);

                      String newDate = "${date.day}/${date.month}/${date.year}";


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("vendorId");
                      print(id);

                      if(id!=null){

                        String apiURL =
                            "$API_BASE_URL/api/v1/vendor/inventory/total-remove-stock";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "vendor":id,
                              "dateAdded":newDate,
                              "coolJarStock":coolJarQty,
                              "bottleJarStock":bottleJarQty
                            }));
                        var body = response.body;

                        var decodedJson = jsonDecode(body);

                        print(body);
                        print(decodedJson);

                        if(decodedJson["success"]!=null && decodedJson["success"]==true){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => TotalInventoryRemovePage()));
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
                                            context, MaterialPageRoute(builder: (context) => TotalInventoryRemovePage()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => TotalInventoryRemovePage()));
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
                                            context, MaterialPageRoute(builder: (context) => TotalInventoryRemovePage()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => TotalInventoryRemovePage()));
                            }
                          });
                        }

                      }


                    }

                  },
                  label: 'SAVE',
                  backgroundColor: Color(0xFF4267B2),
                ),
                CardSettingsButton(
                  onPressed: (){
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => TotalInventoryRemovePage()));
                  },
                  label: 'Cancel',
                  isDestructive: true,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  bottomSpacing: 4.0,
                )

              ],
            ),

          ],
        ),
      ),
    );
  }
}
