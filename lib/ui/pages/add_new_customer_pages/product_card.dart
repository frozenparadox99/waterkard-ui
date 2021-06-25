import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final String customerId;
  ProductCard(this.customerId);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _productKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _rateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _balanceKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dispensersKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _depositKey = GlobalKey<FormState>();
  String uid;

  String product;
  String rate;
  String balance;
  String dispensers;
  String deposit;

  List allProductsForCustomer = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  void getAllProducts () async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var id = prefs.getString("vendorId");
    // print(id);

    if(widget.customerId!=null){
      String apiURL =
          "http://192.168.29.79:4000/api/v1/vendor/customer/products/all?customerId=${widget.customerId}";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customerProducts"]!=null){
        List<dynamic> receivedProducts = decodedJson["data"]["customerProducts"];

        setState(() {
          allProductsForCustomer = receivedProducts;
        });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: CardSettings(

                  contentAlign: TextAlign.right,
                  children: <CardSettingsSection>[
                    CardSettingsSection(
                      header: CardSettingsHeader(
                        label: 'Mr. Shivraj Patil',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[

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
                              print(product);
                              print(rate);
                              print(balance);
                              print(dispensers);
                              print(deposit);
                              print(widget.customerId);


                              var newAddress = {
                                "type":"Point",
                                "coordinates":[12.9716,77.5946]
                              };



                              if(widget.customerId!=null){

                                String apiURL =
                                    "http://192.168.29.79:4000/api/v1/vendor/customer/add-product";
                                var response = await http.post(Uri.parse(apiURL),
                                    headers: <String, String>{
                                      'Content-Type': 'application/json; charset=UTF-8',
                                    },
                                    body:jsonEncode( <String, dynamic>{
                                      "product":product,
                                      "balanceJars":balance,
                                      "dispenser":dispensers,
                                      "deposit":deposit,
                                      "rate":rate,
                                      "customer":widget.customerId
                                    }));
                                var body = response.body;

                                var decodedJson = jsonDecode(body);

                                print(body);
                                print(decodedJson);



                                getAllProducts();

                              }


                            }

                          },

                          label: 'SAVE',
                          backgroundColor: Color(0xFF4267B2),
                        ),

                        CardSettingsButton(
                          label: 'CANCEL',
                          isDestructive: true,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          bottomSpacing: 4.0,
                        )

                      ],
                    ),
                    // CardSettingsSection(
                    //
                    //   header: CardSettingsHeader(
                    //     label: 'Actions',
                    //   ),
                    //   children: <CardSettingsWidget>[
                    //     CardSettingsButton(
                    //
                    //       label: 'SAVE',
                    //       backgroundColor: Color(0xFF80D8FF),
                    //     ),
                    //     CardSettingsButton(
                    //       label: 'CANCEL',
                    //       isDestructive: true,
                    //       backgroundColor: Colors.red,
                    //       textColor: Colors.white,
                    //       bottomSpacing: 4.0,
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Center(
                  child: Text(
                    'Products',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
              // SizedBox(height: 20.0,),
              // DataTable(
              //   columns: [
              //     DataColumn(label: Text(
              //         'ID',
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              //     )),
              //     DataColumn(label: Text(
              //         'Name',
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              //     )),
              //     DataColumn(label: Text(
              //         'Price',
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              //     )),
              //   ],
              //   rows: [
              //     DataRow(cells: [
              //       DataCell(Text('1')),
              //       DataCell(Text('18L Cool Jar')),
              //       DataCell(Text('Rs.50')),
              //     ]),
              //     DataRow(cells: [
              //       DataCell(Text('2')),
              //       DataCell(Text('20L Jar')),
              //       DataCell(Text('Rs.60')),
              //     ]),
              //
              //
              //   ],
              // ),
              SizedBox(height: 20.0,),


              ...allProductsForCustomer.map((e) =>
                _productCardBuilder(e["product"], e["rate"], e["balanceJars"], e["deposit"], e["dispenser"], e["_id"])
              ).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Container _productCardBuilder(productRes,rateRes,balanceJars,depositRes,dispenserRes,productIdRes){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
                backgroundImage: productRes=="18L"?AssetImage("assets/product-card-jar.jpg") : AssetImage("assets/onboarding-image-3.jpg"),
                radius: 36.0,
              ),
              RichText(
                text: TextSpan(
                  text: '$productRes Jar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\nPrice: Rs.$rateRes',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Icon(
              //     Icons.arrow_forward_ios,
              //     color: Colors.grey[400],
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Divider(
            color: Colors.grey[200],
            height: 3,
            thickness: 1,
          ),
          SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _iconBuilder(Icons.edit, 'Edit'),
              _iconBuilder(Icons.cancel, 'Delete'),
              _iconBuilder(Icons.person, '$balanceJars'),
              _iconBuilder(Icons.money, '$depositRes'),
            ],
          )
        ],
      ),
    );
  }

  Column _iconBuilder(icon, title) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 28,
          color: Colors.indigo[400],
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
