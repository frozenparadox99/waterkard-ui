import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

import 'orders_dashboard.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({Key key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _groupKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customersKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _jarKey = GlobalKey<FormState>();
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
  String jarQty = "";
  DateTime date = DateTime.now();


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

  void getCustomerProducts (id) async {

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/customer/products/all?customerId=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customerProducts"]!=null){
        List<dynamic> receivedGroups = decodedJson["data"]["customerProducts"];
        receivedGroups.forEach((ele) {

          setState(() {
            customerProductNames.add(ele["product"]);
            customerProductIds.add(ele["_id"]);
          });
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {},
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: ()  {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: ()  {},
          ),
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
                label: 'Add New Order',
                labelAlign: TextAlign.center,
              ),
              children: <CardSettingsWidget>[
                CardSettingsListPicker(
                  icon: Icon(Icons.group),
                  key: _customersKey,
                  label: 'Customers',
                  initialValue: 'Default',
                  hintText: 'Select Customer',
                  options: allCustomerNames,
                  values: allCustomerIds,
                  onChanged: (value) async{

                    setState(() {
                      customerSelected = value;
                      customerProductNames=[];
                      customerProductIds=[];
                    });
                    getCustomerProducts(value);
                  },
                ),
                CardSettingsListPicker(
                  icon: Icon(Icons.group),
                  key: _productsKey,
                  label: 'Products',
                  initialValue: 'Default',
                  hintText: 'Select Product',
                  options: customerProductNames,
                  values: customerProductIds,
                  onChanged: (value) {
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
                  initialValue:  DateTime(2020, 10, 10, 20, 30),
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },

                ),
                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: 'Jar Qty',
                  hintText: 'Enter Jar Quantity',
                  key: _jarKey,
                  onChanged: (value) {
                    setState(() {
                      jarQty = value;
                    });
                  },
                ),






                CardSettingsButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){

                    print(date);
                    print(jarQty);
                    print(customerSelected);
                    print(productSelected);
                    print(date.day);
                    print(date.month);
                    print(date.year);

                    String newDate = "${date.day}/${date.month}/${date.year}";


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("vendorId");
                      print(id);

                      if(id!=null){

                        String apiURL =
                            "$API_BASE_URL/api/v1/vendor/order";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "vendor":id,
                              "jarQty":jarQty,
                              "preferredDate":newDate,
                              "product":productSelected,
                              "customer":customerSelected
                            }));
                        var body = response.body;

                        var decodedJson = jsonDecode(body);

                        print(body);
                        print(decodedJson);

                        if(decodedJson["success"]!=null && decodedJson["success"]==true){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => OrderDashboard()));
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
                                            context, MaterialPageRoute(builder: (context) => OrderDashboard()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => OrderDashboard()));
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
                                            context, MaterialPageRoute(builder: (context) => OrderDashboard()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => OrderDashboard()));
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
                        context, MaterialPageRoute(builder: (context) => OrderDashboard()));
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
