import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/cards_customer/newCustomerCards.dart';
import 'package:waterkard/ui/pages/map_views/pick_location.dart';
import 'package:waterkard/ui/pages/vendor_home_page.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';
import 'package:geocoder/geocoder.dart';

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
  String mobileNumber;
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
  double latitude;
  double longitude;

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
          "$API_BASE_URL/api/v1/vendor/group/all?vendor=$id";
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
                label: 'Add New Customer',
                labelAlign: TextAlign.center,
              ),
              children: [
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
                CardSettingsText(
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
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Location Details',
                labelAlign: TextAlign.center,
              ),
              children: [

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
                  maxLength: 200,
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
                CardSettingsButton(
                  onPressed: () async{
                    var first;
                    if(address!=null){
                      print("theeere");
                      print(address);
                      try{
                        var addresses = await Geocoder.local.findAddressesFromQuery(address);
                        first = addresses.first;
                        print("${first.featureName} : ${first.coordinates}");
                      } catch(e){
                        print(e);
                      }

                    }

                    double latToSend = 24.4;
                    double longToSend = 77.6;

                    print(address);
                    print("here");


                    if(first != null){
                      latToSend = first.coordinates!=null?first.coordinates.latitude:24.4;
                      longToSend = first.coordinates!=null?first.coordinates.longitude:77.6;
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        PickLocation( latToSend,longToSend))).then((  _latlng) {
                      print("-----------------------------------------------");
                      print(_latlng);
                      print(_latlng.toString().split("LatLng("));
                      var new_str_arr = _latlng.toString().split("LatLng(")[1].split(",");
                      print(double.parse(new_str_arr[0]));
                      print(double.parse(new_str_arr[1].split(")")[0]));
                      setState(() {
                        latitude = double.parse(new_str_arr[0]);
                        longitude = double.parse(new_str_arr[1].split(")")[0]);
                      });

                    });
                  },
                  label: latitude==null?'Pick Address Location':'[$latitude, $longitude]',
                  backgroundColor: Colors.blueAccent,
                  textColor: Colors.white,
                  bottomSpacing: 10.0,
                ),
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Customer Data',
                labelAlign: TextAlign.center,
              ),
              children: <CardSettingsWidget>[

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
                        "coordinates":[latitude,longitude]
                      };

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getString("vendorId");
                      print(id);

                      if(id!=null){

                        String apiURL =
                            "$API_BASE_URL/api/v1/vendor/customer";
                        var response = await http.post(Uri.parse(apiURL),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body:jsonEncode( <String, dynamic>{
                              "typeOfCustomer":"Regular",
                              "name":name,
                              "mobileNumber":"+91$mobileNumber",
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
                              context, MaterialPageRoute(builder: (context) => ProductCard(decodedJson["data"]["customer"]["_id"])));
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
                                Text("${decodedJson['message']}. Customer with the entered mobile number already exists",
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
                                            context, MaterialPageRoute(builder: (context) => CustomerCard()));
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ).then((value) {
                            if(value!=null && value=="closePage"){
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => CustomerCard()));
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
                  textColor: Colors.white,
                  backgroundColor: Color(0xFF4267B2),
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
