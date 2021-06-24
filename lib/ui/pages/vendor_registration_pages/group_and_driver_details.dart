import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:waterkard/ui/pages/vendor_details_pages/vendor_get_details.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/pages/vendor_registration_pages/general_details.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GroupAndDriverDetailsPage extends StatefulWidget {
  final String phoneNumber;
  final String brand;
  final String fullBrandName;
  final String stateOfIndia;
  final String name;
  final String city;
  final String country;
  final String coolJarStock;
  final String bottleJarStock;
  GroupAndDriverDetailsPage(this.phoneNumber,
      this.brand,
      this.fullBrandName,
      this.stateOfIndia,
      this.name,
      this.city,
      this.country,
      this.coolJarStock,
      this.bottleJarStock );

  @override
  _GroupAndDriverDetailsPageState createState() => _GroupAndDriverDetailsPageState();
}

class _GroupAndDriverDetailsPageState extends State<GroupAndDriverDetailsPage> {
  final String apiURL =
      "http://192.168.29.79:4000/api/v1/vendor/auth/register";
  final _formKey = GlobalKey<FormState>();
  final _createGroupController = TextEditingController();
  final _driverNameController = TextEditingController();
  final _driverNumberController = TextEditingController();

  String currentStateSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStateSelected = "";
  }



  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(

            color: Color(0xFF5F6AF8),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircularPercentIndicator(
                        radius: 170.0,
                        lineWidth: 12.0,
                        animation: true,
                        backgroundColor: Colors.white,
                        percent: 0.66,
                        center: Text(
                          "Registration Progress",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressColor: Color(0xFF1EAE98),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Text("Driver And Group Details", style: TextStyle(color: Colors.white, fontSize: 20),),
                    ),
                  ],
                ),
              ),

              Expanded(child: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60),
                        )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: 30,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: <Widget>[


                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: _buildForm(),
                                ),

                                InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      print(widget.bottleJarStock);
                                      print(widget.coolJarStock);
                                      print(widget.stateOfIndia);
                                      print(widget.fullBrandName);
                                      print(widget.brand);
                                      print(widget.phoneNumber);
                                      print(widget.name);
                                      print(widget.country);
                                      print(widget.city);
                                      print(_createGroupController.text);
                                      print(_driverNameController.text);
                                      print(_driverNumberController.text);

                                      var response = await http.post(Uri.parse(apiURL),
                                          headers: <String, String>{
                                            'Content-Type': 'application/json; charset=UTF-8',
                                          },
                                          body:jsonEncode( <String, String>{
                                        "coolJarStock":widget.coolJarStock,
                                        "bottleJarStock":widget.bottleJarStock,
                                        "defaultGroupName":_createGroupController.text,
                                        "firstDriverName":_driverNameController.text,
                                        "firstDriverMobileNumber":"+91${_driverNumberController.text}",
                                        "fullBusinessName":widget.fullBrandName,
                                        "fullVendorName":widget.name,
                                        "mobileNumber":"+91${widget.phoneNumber}",
                                        "country":widget.country,
                                        "city":widget.city,
                                        "state":widget.stateOfIndia,
                                        "brandName":widget.brand,
                                      }));

                                      var body = response.body;

                                      var decodedJson = jsonDecode(body);

                                      print(body);
                                      print(decodedJson);

                                      if(decodedJson["success"]!=null && decodedJson["success"] == true){
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.setString("vendorId", decodedJson["data"]["vendor"]["_id"]);
                                        var id = prefs.getString("vendorId");
                                        print(id);
                                        if(id != null){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VendorLoginPage()),
                                          );
                                        }

                                      }



                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 20),
                                    width: scrWidth * 0.85,
                                    height: 75,
                                    decoration: BoxDecoration(
                                      color: Color(0xff5f69f8),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontFamily: 'ProductSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GeneralDetailsPage()));
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Want to change something? ',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff8f9db5).withOpacity(0.8),
                                          ),
                                        ),

                                        TextSpan(
                                          text: 'Go Back',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff5f69f8),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),



                              ],
                            ),
                          ),
                          SizedBox(height: 40,),


                          SizedBox(height: 10,),


                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),

      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(

              controller: _createGroupController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Group Name can not be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Default Group Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(

              controller: _driverNameController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Driver Name can not be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Add Driver Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: _driverNumberController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Mobile Number cannot be empty';
                } else if (value.length != 10) {
                  return 'Mobile Number must be 10 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Driver Mobile Number',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


