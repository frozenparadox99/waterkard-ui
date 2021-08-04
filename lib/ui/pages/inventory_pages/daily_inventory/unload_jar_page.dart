import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_load.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_unload.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';


class UnloadJarPage extends StatefulWidget {
  const UnloadJarPage({Key key}) : super(key: key);

  @override
  _UnloadJarPageState createState() => _UnloadJarPageState();
}

class _UnloadJarPageState extends State<UnloadJarPage> {
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

  List<dynamic> allDriverNames = <String>[];
  List<dynamic> allDriverIds = <String>[];

  List<String> customerProductNames = <String>[];
  List<String> customerProductIds = <String>[];

  String driverSelected="";

  String bottleJarQty = "";
  String coolJarQty = "";
  String unloadReturned18;
  String unloadReturned20;
  String unloadEmpty18;
  String unloadEmpty20;
  String expectedReturned18="";
  String expectedReturned20="";
  String expectedEmpty18="";
  String expectedEmpty20="";
  DateTime date = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;

    getAllDrivers();

  }

  void getAllDrivers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/driver/all?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["drivers"]!=null){
        List<dynamic> receivedGroups = decodedJson["data"]["drivers"];
        receivedGroups.forEach((ele) {

          setState(() {
            allDriverNames.add(ele["name"]);
            allDriverIds.add(ele["_id"]);
          });
        });
      }

    }
  }

  void getExpectedUnload() async{


    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      var now = new DateTime.now();
      var date = "${now.day}/${now.month}/${now.year}";

      String apiURL =
          "$API_BASE_URL/api/v1/vendor/inventory/get-expected-unload?vendor=$id&date=$date&driver=$driverSelected";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true){
        setState(() {
          if(decodedJson["data"]["expectedReturned18"]!=null){
            expectedReturned18 = decodedJson["data"]["expectedReturned18"].toString();
          }
          if(decodedJson["data"]["expectedReturned20"]!=null){
            expectedReturned20 = decodedJson["data"]["expectedReturned20"].toString();
          }
          if(decodedJson["data"]["expectedEmpty18"]!=null){
            expectedEmpty18 = decodedJson["data"]["expectedEmpty18"].toString();
          }
          if(decodedJson["data"]["expectedEmpty20"]!=null){
            expectedEmpty20 = decodedJson["data"]["expectedEmpty20"].toString();
          }
        });

      }
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text("Daily Inventory"),
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
                label: 'Daily Unload',
                labelAlign: TextAlign.center,
              ),
              children: <CardSettingsWidget>[
                CardSettingsListPicker(
                  icon: Icon(Icons.group),
                  key: _customersKey,
                  label: 'Drivers',
                  initialValue: 'Default',
                  hintText: 'Select Driver',
                  options: allDriverNames,
                  values: allDriverIds,
                  onChanged: (value) async{
                    setState(() {
                      driverSelected = value;
                    });
                  getExpectedUnload();
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
                  label: '18L Returned',
                  hintText:expectedReturned18==""? 'Enter Returned Jars':expectedReturned18,
                  key: _jarKey,
                  onChanged: (value) {
                    setState(() {
                      unloadReturned18 = value;
                    });
                  },
                ),

                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: '20L Returned',
                  hintText: expectedReturned20==""? 'Enter Returned Jars':expectedReturned20,
                  key: _productsKey,
                  onChanged: (value) {
                    setState(() {
                      unloadReturned20 = value;
                    });
                  },
                ),

                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: '18L Empty',
                  hintText: expectedEmpty18==""? 'Enter Returned Jars':expectedEmpty18,
                  key: _nameKey,
                  onChanged: (value) {
                    setState(() {
                      unloadEmpty18 = value;
                    });
                  },
                ),

                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: '20L Empty',
                  hintText: expectedEmpty20==""? 'Enter Returned Jars':expectedEmpty20,
                  key: _groupKey,
                  onChanged: (value) {
                    setState(() {
                      unloadEmpty20 = value;
                    });
                  },
                ),






                CardSettingsButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){

                      print(date);
                      print(unloadEmpty18);
                      print(unloadEmpty20);
                      print(unloadReturned18);
                      print(unloadReturned20);
                      print(driverSelected);
                      print(date.day);
                      print(date.month);
                      print(date.year);

                      String newDate = "${date.day}/${date.month}/${date.year}";


                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("vendorId");
                      print(id);

                      if(id!=null){

                        String apiURL =
                            "$API_BASE_URL/api/v1/vendor/inventory/daily-unload";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "vendor":id,
                              "unloadEmpty18":unloadEmpty18,
                              "date":newDate,
                              "unloadEmpty20":unloadEmpty20,
                              "driver":driverSelected,
                              "unloadReturned18":unloadReturned18,
                              "unloadReturned20":unloadReturned20,
                            }));
                        var body = response.body;

                        var decodedJson = jsonDecode(body);

                        print(body);
                        print(decodedJson);

                        if(decodedJson["success"]!=null && decodedJson["success"]==true){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => DailyInventoryUnloadPage()));
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
                                            context, MaterialPageRoute(builder: (context) => DailyInventoryUnloadPage()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => DailyInventoryUnloadPage()));
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
                                            context, MaterialPageRoute(builder: (context) => DailyInventoryUnloadPage()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => DailyInventoryUnloadPage()));
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
