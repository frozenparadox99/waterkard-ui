import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/ui/pages/order/add_order.dart';
import 'package:waterkard/ui/pages/order/filter_order.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../vendor_login_page.dart';

final Color activeColor = Color(0xffFF2E63);
final Color inactiveColor = Color(0xff6C73AE);
const kBackgroundColor = Color(0xffF6F6F6);
const kAccentColor = Color(0xff03A5E1);
const kBlackColor = Color(0xFF212121);
const kGreyColor = Color(0x50212121);
const kWhiteColor = Color(0xFFFFFFFF);
const kWhiteGreyColor = Color(0xFFF9F9F9);
const kGreenColor = Color(0xFF36B552);
const kOrangeColor = Color(0xFFFF9C41);
const kBlueColor = Color(0xFF3B64F4);
const kJeniusCardColor = Color(0xFF03A5e1);
const kMasterCardColor = Color(0xFFF5F5F5);
const kGradientSlideButton = [const Color(0xFF3B64F4), const Color(0xFF6822FD)];
String selection;
List<String> listItems = ["Recent", "Ascending", "Descending"];

class OrderDashboard extends StatefulWidget {
  const OrderDashboard({Key key}) : super(key: key);

  @override
  _OrderDashboardState createState() => _OrderDashboardState();
}

class _OrderDashboardState extends State<OrderDashboard> {
  String uid;
  String currentStateSelected;
  int selectedRadio;

  List<dynamic> allOrdersForVendor = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    selectedRadio = 0;
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllOrders();
  }

  void getAllOrders () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/order/all?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["orders"]!=null){
        List<dynamic> receivedProducts = decodedJson["data"]["orders"];
        List<dynamic> formatted = [];
        if(decodedJson["data"]["orders"].length!=0){
          formatted = receivedProducts.map((e) => {
            "load": e["jarQty"].toString(),
            "product":e["product"]["product"],
            "customerName": e["customer"]["name"],
            "customerMobileNumber": e["customer"]["mobileNumber"],
            "date": "${DateTime.parse(e["preferredDate"]).day}/${DateTime.parse(e["preferredDate"]).month}/${DateTime.parse(e["preferredDate"]).year}" ,
            "jarQty":e["jarQty"].toString(),
          }).toList();
        }


        setState(() {
          allOrdersForVendor = formatted;
        });

      }

    }
  }

  setSelectedRadioButton(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4267B2),
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Groups'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddOrder()));
            },
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
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              )
          ),
          child: Column(
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Text("All Orders", style: TextStyle(color: Colors.black, fontSize: 40),),
                    ),

                  ],
                ),
              ),

              ...allOrdersForVendor.map((e) =>
                  OrderDisplay(load: e["load"],
                    product: e["product"],
                    customerName: e["customerName"],
                    customerMobileNumber: e["customerMobileNumber"],
                    date: e["date"],
                    jarQty: e["jarQty"],
                  )
              ).toList(),

              SizedBox(height: 40,),
              SizedBox(height: 40,),
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
    );
  }
}

class OrderDisplay extends StatefulWidget {
  final String load,product,customerName,customerMobileNumber,date,jarQty;
  OrderDisplay({ this.load,this.product,this.customerName,this.customerMobileNumber,this.date,this.jarQty});

  @override
  _OrderDisplayState createState() => _OrderDisplayState();
}

class _OrderDisplayState extends State<OrderDisplay> {
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 1.0,
                backgroundColor: Colors.white,
                child: Container(
                  width: 500,
                  height: 500,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Product',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '${this.widget.product}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '${this.widget.customerName}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '${this.widget.customerMobileNumber}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '${this.widget.date}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Jar Qty.',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            '${this.widget.jarQty}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Share on Whatsapp'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Center(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 1.0,
                                            backgroundColor: Colors.white,
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(height: 20),
                                                  Text(
                                                    'Are You Sure',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Cancel the Order',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          RaisedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('NO'),
                                                            color: Colors.blue,
                                                          ),
                                                          SizedBox(
                                                            width: 50,
                                                          ),
                                                          RaisedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('YES'),
                                                            color: Colors.red,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  child: Text('Cancel'),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Process Order'),
                              color: Colors.blue,
                            ),
                          ],
                        )),
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        margin: EdgeInsets.only(bottom: 8),
        height: 68,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Color(0x04000000),
                  blurRadius: 10,
                  spreadRadius: 10,
                  offset: Offset(0.0, 8.0))
            ],
            color: kWhiteColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 12,
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kWhiteGreyColor,
                    image: DecorationImage(
                      image: AssetImage("assets/profile_user.jpg"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      this.widget.customerName,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kBlackColor),
                    ),
                    Row(
                      children: [
                        Text(
                          "Time: ${this.widget.date}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kGreyColor),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Qty: ${this.widget.load}",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: kGreyColor),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 1.0,
                            backgroundColor: Colors.white,
                            child: Container(
                              width: 500,
                              height: 500,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Edit Order',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Customer',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton(
                                        value: selection,
                                        hint: Text(
                                          "Choose",
                                          style: TextStyle(
                                            color: activeColor.withOpacity(0.5),
                                            fontSize: 17,
                                          ),
                                        ),
                                        dropdownColor: Color(0xff010A43),
                                        iconEnabledColor: activeColor,
                                        style: TextStyle(
                                          color: activeColor,
                                          fontSize: 17,
                                        ),
                                        items: listItems.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selection = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Product',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton(
                                        value: selection,
                                        hint: Text(
                                          "Choose",
                                          style: TextStyle(
                                            color: activeColor.withOpacity(0.5),
                                            fontSize: 17,
                                          ),
                                        ),
                                        dropdownColor: Color(0xff010A43),
                                        iconEnabledColor: activeColor,
                                        style: TextStyle(
                                          color: activeColor,
                                          fontSize: 17,
                                        ),
                                        items: listItems.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selection = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Prefered Date',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton(
                                        value: selection,
                                        hint: Text(
                                          "Choose",
                                          style: TextStyle(
                                            color: activeColor.withOpacity(0.5),
                                            fontSize: 17,
                                          ),
                                        ),
                                        dropdownColor: Color(0xff010A43),
                                        iconEnabledColor: activeColor,
                                        style: TextStyle(
                                          color: activeColor,
                                          fontSize: 17,
                                        ),
                                        items: listItems.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selection = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Prefered Time',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton(
                                        value: selection,
                                        hint: Text(
                                          "Choose",
                                          style: TextStyle(
                                            color: activeColor.withOpacity(0.5),
                                            fontSize: 17,
                                          ),
                                        ),
                                        dropdownColor: Color(0xff010A43),
                                        iconEnabledColor: activeColor,
                                        style: TextStyle(
                                          color: activeColor,
                                          fontSize: 17,
                                        ),
                                        items: listItems.map((e) {
                                          return DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selection = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Jar Qty.',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        '20',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.share,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('Share on Whatsapp'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Update'),
                                            color: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: () {
                    print("Pressed");
                  },
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
