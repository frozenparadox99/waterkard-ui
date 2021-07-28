import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/total_inventory_add.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AddJar extends StatefulWidget {
  const AddJar({Key key}) : super(key: key);

  @override
  _AddJarState createState() => _AddJarState();
}

class _AddJarState extends State<AddJar> {
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
  DateTime date ;


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
                label: 'Add Inventory',
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
                            "$API_BASE_URL/api/v1/vendor/inventory/total-add-stock";
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
                              context, MaterialPageRoute(builder: (context) => TotalInventoryAddPage()));
                        }

                      }


                    }

                  },
                  label: 'SAVE',
                  backgroundColor: Color(0xFF4267B2),
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
