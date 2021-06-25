import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_load.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LoadJarPage extends StatefulWidget {
  const LoadJarPage({Key key}) : super(key: key);

  @override
  _LoadJarPageState createState() => _LoadJarPageState();
}

class _LoadJarPageState extends State<LoadJarPage> {
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
  DateTime date ;


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
          "http://192.168.29.79:4000/api/v1/vendor/driver/all?vendor=$id";
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
                label: 'Add Daily Load',
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
                  label: '18L Load',
                  hintText: 'Enter Jar Quantity',
                  key: _jarKey,
                  onChanged: (value) {
                    setState(() {
                      coolJarQty = value;
                    });
                  },
                ),

                CardSettingsText(
                  icon: Icon(Icons.format_list_numbered),
                  label: '20L Load',
                  hintText: 'Enter Jar Quantity',
                  key: _productsKey,
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
                            "http://192.168.29.79:4000/api/v1/vendor/inventory/daily-load";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "vendor":id,
                              "load20":bottleJarQty,
                              "date":newDate,
                              "load18":coolJarQty,
                              "driver":driverSelected
                            }));
                        var body = response.body;

                        var decodedJson = jsonDecode(body);

                        print(body);
                        print(decodedJson);

                        if(decodedJson["success"]!=null && decodedJson["success"]==true){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => DailyInventoryLoadPage()));
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
