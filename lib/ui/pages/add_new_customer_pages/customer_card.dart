import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerCard extends StatefulWidget {
  const CustomerCard({Key key}) : super(key: key);

  @override
  _CustomerCardState createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _mobileNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _cityKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _groupKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _pincodeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _rateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _balanceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dispensersKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _depositKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _areaKey = GlobalKey<FormState>();
  String uid;

  var allGroupNames = <String>[];
  var allGroupIds = <String>[];


  String name;
  int mobileNumber;
  String city="Mumbai";
  String group;
  String product;
  String address;
  String pincode;
  String rate;
  String balance;
  String dispensers;
  String deposit;
  String email;
  String area;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;

    getAllGroups();

  }

  void getAllGroups () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "http://192.168.29.79:4000/api/v1/vendor/group/all?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["groups"]!=null){
        List<dynamic> receivedGroups = decodedJson["data"]["groups"];
        receivedGroups.forEach((ele) {
          allGroupNames.add(ele["name"]);
          allGroupIds.add(ele["_id"]);
        });
        print(allGroupNames);
        print(allGroupIds);
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
                label: 'Add New Customer',
                labelAlign: TextAlign.center,
              ),
              children: <CardSettingsWidget>[
                CardSettingsText(
                  icon: Icon(Icons.person_add_alt_1),
                  label: 'Name',
                  hintText: 'Enter Customer Name',
                  key: _nameKey,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                CardSettingsPhone(
                  icon: Icon(Icons.phone_android),
                  hintText: 'Enter Phone Number',
                  label: 'Mobile',
                  key: _mobileNumberKey,
                  onChanged: (value) {
                    setState(() {
                      mobileNumber = value;
                    });
                  },
                ),
                CardSettingsListPicker(
                  icon: Icon(Icons.location_city_sharp),
                  key: _cityKey,
                  label: 'City',
                  initialValue: 'Mumbai',
                  hintText: 'Select One',
                  options: <String>['Mumbai', 'Pune', 'Noida', 'Bangalore'],
                  values: <String>['Mumbai', 'Pune', 'Noida', 'Bangalore'],
                  onChanged: (value) {
                    setState(() {
                      city = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.location_on),
                  label: 'Address',
                  hintText: 'Enter Customer Address',
                  key: _addressKey,
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.person_pin_circle),
                  label: 'Pincode',
                  hintText: 'Enter Customer Pincode',
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
                  hintText: 'Enter Customer Area',
                  key: _areaKey,
                  onChanged: (value) {
                    setState(() {
                      area = value;
                    });
                  },
                ),
                CardSettingsEmail(
                  icon: Icon(Icons.person),
                  key: _emailKey,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                CardSettingsListPicker(
                  icon: Icon(Icons.group),
                  key: _groupKey,
                  label: 'Group',
                  initialValue: 'Default',
                  hintText: 'Select Group',
                  options: allGroupNames,
                  values: allGroupIds,
                  onChanged: (value) {
                    setState(() {
                      group = value;
                    });
                  },
                ),
                CardSettingsListPicker(
                  icon: Icon(Icons.shopping_cart_outlined),
                  key: _productKey,
                  label: 'Product',
                  initialValue: '18 Litre Jar',
                  hintText: 'Select Jar',
                  options: <String>['18 L Jar', '20 L Jar'],
                  values: <String>['18L', '20L'],
                  onChanged: (value) {
                    setState(() {
                      product = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.money),
                  label: 'Rate',
                  hintText: 'Enter Rate Of Jar',
                  key: _rateKey,
                  onChanged: (value) {
                    setState(() {
                      rate = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.water_damage),
                  label: 'Balance',
                  hintText: 'Enter the number of previous jars',
                  key: _balanceKey,
                  onChanged: (value) {
                    setState(() {
                      balance = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.settings_display),
                  label: 'Dispensers',
                  hintText: 'Enter Dispensers',
                  key: _dispensersKey,
                  onChanged: (value) {
                    setState(() {
                      dispensers = value;
                    });
                  },
                ),
                CardSettingsText(
                  icon: Icon(Icons.credit_card),
                  label: 'Deposit',
                  hintText: 'Enter Customer Deposit',
                  key: _depositKey,
                  onChanged: (value) {
                    setState(() {
                      deposit = value;
                    });
                  },
                ),
                CardSettingsButton(
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      print(name);
                      print(mobileNumber);
                      print(city);
                      print(group);
                      print(product);
                      print(address);
                      print(pincode);
                      print(rate);
                      print(balance);
                      print(dispensers);
                      print(deposit);
                      print(email);
                      print(area);

                      var newAddress = {
                        "type":"Point",
                        "coordinates":[12.9716,77.5946]
                      };

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("vendorId");
                      print(id);

                      if(id!=null){

                        String apiURL =
                            "http://192.168.29.79:4000/api/v1/vendor/customer";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "typeOfCustomer":"Regular",
                              "name":name,
                              "mobileNumber":"+91${mobileNumber.toString()}",
                              "address":newAddress,
                              "city":city,
                              "pincode":pincode,
                              "group":group,
                              "vendor":id,
                              "product":product,
                              "balanceJars":balance,
                              "dispenser":dispensers,
                              "deposit":deposit,
                              "rate":rate,
                              "email":email,
                              "area":area
                            }));
                        var body = response.body;

                        var decodedJson = jsonDecode(body);

                        print(body);
                        print(decodedJson);

                        if(decodedJson["success"]!=null && decodedJson["success"]==true){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => ProductCard()));
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
