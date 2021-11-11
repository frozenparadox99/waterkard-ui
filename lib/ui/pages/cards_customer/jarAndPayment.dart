import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/whatsapp_service.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/cards_customer/cards.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/add_payment.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/new_driver_payment_list.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';
import 'package:waterkard/ui/widgets/shared_button.dart';

import 'newCustomerCards.dart';


class JarAndPaymentPage extends StatefulWidget {
  String customerId;
  String driverId;
  String mobileNumber;


  JarAndPaymentPage(this.customerId,this.driverId,this.mobileNumber);

  @override
  _JarAndPaymentPageState createState() => _JarAndPaymentPageState();
}

class _JarAndPaymentPageState extends State<JarAndPaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _groupKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _customersKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productsKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _soldJarKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emptyCollectedKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _prevBaldKey = GlobalKey<FormState>();
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
  int soldJarQty = 0;
  int emptyJarQty = 0;
  DateTime date = DateTime.now() ;
  int prevBalance = 0;
  int currBalance = 0;



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
    var bal = prefs.getInt("balance");
    print(bal);
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
            prevBalance=bal;
            currBalance=bal;
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
                  initialValue:  date,
                  onChanged: (value) {
                    setState(() {
                      date = value;
                    });
                  },

                ),

                CardSettingsInt(
                  icon: Icon(Icons.format_list_numbered),
                  label: 'Sold Jars',
                  hintText: 'Enter Jar Quantity',
                  key: _soldJarKey,
                  initialValue: 0,
                  onChanged: (value) {
                    print(currBalance);
                    setState(() {
                      if(value!=null){
                        soldJarQty = value;

                      }

                    });
                  },
                ),
                CardSettingsInt(
                  icon: Icon(Icons.format_list_numbered),
                  label: 'Empty Collected',
                  hintText: 'Enter Jar Quantity',
                  key: _emptyCollectedKey,
                  initialValue: 0,
                  onChanged: (value) {
                    print(currBalance);
                    setState(() {
                      if( value!=null){
                        emptyJarQty = value;


                      }

                    });
                  },
                ),
                CardSettingsText(

                  icon: Icon(Icons.format_list_numbered),
                  label: 'Balance: ${prevBalance+soldJarQty-emptyJarQty}',
                  key: _prevBaldKey,



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


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("vendorId");
                      print(id);

                      if(id!=null){

                        String apiURL =
                            "$API_BASE_URL/api/v1/vendor/driver/add-transaction";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "vendor":id,
                              "driver":this.widget.driverId,
                              "date":newDate,
                              "product":productSelected,
                              "customer":this.widget.customerId,
                              "soldJars":soldJarQty,
                              "emptyCollected":emptyJarQty,
                              "status":"completed"
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ShareButton(
                                    //   onPressed: (){
                                    //     WhatsAppService().toContact(
                                    //       contactNumber: widget.mobileNumber,
                                    //       message: "Order has been logged for $soldJarQty $productSelected jars.",
                                    //     );
                                    //   },
                                    //   height: 40,
                                    //   paddingHorizontal: 15,
                                    //   textSize: 18,
                                    // ),
                                    MaterialButton(
                                      child: Text(
                                        "Add Payment",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                      ),
                                      onPressed: (){
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(builder: (context) => AddPayment()));
                                      },
                                    ),
                                    // MaterialButton(
                                    //   child: Text(
                                    //     "Cancel",
                                    //     style: TextStyle(
                                    //         fontSize: 18
                                    //     ),
                                    //   ),
                                    //   onPressed: (){
                                    //     Navigator.pushReplacement(
                                    //         context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
                                    //   },
                                    // ),
                                  ],
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
                                    // MaterialButton(
                                    //   child: Text(
                                    //     "Add Payment",
                                    //     style: TextStyle(
                                    //         fontSize: 12
                                    //     ),
                                    //   ),
                                    //   onPressed: (){
                                    //     Navigator.pushReplacement(
                                    //         context, MaterialPageRoute(builder: (context) => NewDriverPaymentList()));
                                    //   },
                                    // ),
                                    MaterialButton(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                      ),
                                      onPressed: (){
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
                            }
                          });

                        }
                        else if (decodedJson["success"]!=null && decodedJson["success"]==false && decodedJson["message"]!=null){
                          print("Here");
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
                                            context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
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
                                            context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
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
                        context, MaterialPageRoute(builder: (context) => NewCustomerCards()));
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
