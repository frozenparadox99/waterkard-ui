import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/services/whatsapp_service.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/cards_customer/cards.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_homepage.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';
import 'package:waterkard/ui/widgets/shared_button.dart';


class DriverJarAndPaymentPage extends StatefulWidget {
  String customerId;
  String driverId;
  String mobileNumber;

  DriverJarAndPaymentPage(this.customerId,this.driverId,this.mobileNumber);

  @override
  _DriverJarAndPaymentPageState createState() => _DriverJarAndPaymentPageState();
}

class _DriverJarAndPaymentPageState extends State<DriverJarAndPaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _groupKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customersKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _soldJarKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emptyCollectedKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  // String uid;

  var allGroupNames = <String>[];
  var allGroupIds = <String>[];

  List<dynamic> allCustomerNames = <String>[];
  List<dynamic> allCustomerIds = <String>[];

  List<String> customerProductNames = <String>[];
  List<String> customerProductIds = <String>[];

  String customerSelected="";
  String productSelected="18L";
  String soldJarQty = "";
  String emptyJarQty = "";
  DateTime date = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // uid = FirebaseAuth.instance.currentUser.uid;

    getAllCustomers();

  }

  void getAllCustomers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("driverVendor");
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
    return Scaffold(
      drawer: SidebarDriver(),
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
            onPressed: ()  {
              // await FirebaseAuth.instance.signOut();
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
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
                  key: _productsKey,
                  label: 'Products',
                  initialValue: 'Default',
                  hintText: 'Select Product',
                  options: ["18L","20L"],
                  values: ["18L","20L"],
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
                  initialValue:  DateTime.now(),
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },

                ),
                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: 'Sold Jars',
                  hintText: 'Enter Jar Quantity',
                  key: _soldJarKey,
                  onChanged: (value) {
                    setState(() {
                      soldJarQty = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: 'Empty Collected',
                  hintText: 'Enter Jar Quantity',
                  key: _emptyCollectedKey,
                  onChanged: (value) {
                    setState(() {
                      emptyJarQty = value;
                    });
                  },
                ),






                CardSettingsButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      print(emptyJarQty);
                      print(soldJarQty);
                      print(date);
                      print(productSelected);
                      print(this.widget.driverId);
                      print(this.widget.customerId);


                      String newDate = "${date.day}/${date.month}/${date.year}";






                      String apiURL =
                          "$API_BASE_URL/api/v1/vendor/driver/add-transaction";
                      var response = await http.post(Uri.parse(apiURL),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body:jsonEncode( <String, dynamic>{
                            "vendor":SharedPrefsService.getDriverVendor(),
                            "driver":this.widget.driverId,
                            "date":newDate,
                            "product":productSelected,
                            "customer":this.widget.customerId,
                            "soldJars":soldJarQty,
                            "emptyCollected":emptyJarQty
                          }));
                      var body = response.body;

                      var decodedJson = jsonDecode(body);

                      print(body);
                      print(decodedJson);

                      if(decodedJson["success"]!=null && decodedJson["success"]==true){
                        successMessageDialogue(
                          context: context,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.library_add_check_outlined,
                                  color: Colors.blue,
                                  size: 100,
                                ),
                              ),
                              SizedBox(height: 20,),
                              Text(
                                "New Order Has Been Added Successfully",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ShareButton(
                                    onPressed: (){
                                      WhatsAppService().toContact(
                                        contactNumber: widget.mobileNumber,
                                        message: "Order has been logged for $soldJarQty $productSelected jars.",
                                      );
                                    },
                                    height: 40,
                                    paddingHorizontal: 15,
                                    textSize: 18,
                                  ),
                                  MaterialButton(
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 18
                                      ),
                                    ),
                                    onPressed: (){
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ).then((value) {
                          if(value!=null && value=="closePage"){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                          }
                        });

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
                                          context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ).then((value) {
                          if(value!=null && value=="closePage"){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => DriverHomePage()));
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
                                          context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ).then((value) {
                          if(value!=null && value=="closePage"){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => DriverHomePage()));
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
                        context, MaterialPageRoute(builder: (context) => DriverHomePage()));
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