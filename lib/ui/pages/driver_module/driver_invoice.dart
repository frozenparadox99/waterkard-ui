import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/driver_module/driver_invoice_pdf.dart';
import 'package:waterkard/ui/pages/invoice_pages/invoice_pdf.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

class DriverInvoice extends StatefulWidget {
  const DriverInvoice({Key key}) : super(key: key);

  @override
  _DriverInvoiceState createState() => _DriverInvoiceState();
}

class _DriverInvoiceState extends State<DriverInvoice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _customerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _startDateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _endDateKey = GlobalKey<FormState>();
  String uid;
  String paymentMethod;
  String customerSelected="";

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  List<dynamic> allCustomerNames = <String>[];
  List<dynamic> allCustomerIds = <String>[];

  Map invoiceMap;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllCustomers();
  }

  void getAllCustomers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("driverId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/driver/customers?driver=$id";
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
    return SafeArea(
      child: Scaffold(
        drawer: SidebarDriver(),
        appBar: AppBar(
          title: Text('Invoice'),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.logout),
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //     Navigator.pushReplacement(
            //         context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            //   },
            // )
          ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 50.0,),
              Form(
                key: _formKey,
                child: CardSettings(

                  contentAlign: TextAlign.right,
                  children: <CardSettingsSection>[
                    CardSettingsSection(
                      header: CardSettingsHeader(
                        label: 'Generate Invoice',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[


                        CardSettingsDatePicker(
                          key: _startDateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'Start Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime(2020, 10, 10, 20, 30),
                          onChanged: (value) {
                            setState(() {
                              startDate = value;
                            });
                          },

                        ),

                        CardSettingsDatePicker(
                          key: _endDateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'End Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime.now(),
                          onChanged: (value) {
                            setState(() {
                              endDate = value;
                            });
                          },

                        ),


                        CardSettingsListPicker(
                          icon: Icon(Icons.group),
                          key: _customerKey,
                          label: 'Customers',
                          initialValue: 'Default',
                          hintText: 'Select Customer',
                          options: allCustomerNames,
                          values: allCustomerIds,
                          onChanged: (value) async{

                            setState(() {
                              customerSelected = value;
                            });
                          },
                        ),





                        CardSettingsButton(
                          onPressed: ()async{

                            String newStartDate = "${startDate.day}/${startDate.month}/${startDate.year}";
                            String newEndDate = "${endDate.day}/${endDate.month}/${endDate.year}";


                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var id = prefs.getString("driverVendor");
                            print(id);

                            if(id!=null){
                              String apiURL =
                                  "$API_BASE_URL/api/v1/vendor/customer/invoice?vendor=$id&customer=$customerSelected&startDate=$newStartDate&endDate=$newEndDate";
                              var response = await http.get(Uri.parse(apiURL));
                              var body = response.body;

                              Map decodedJson = jsonDecode(body);

                              print(body);
                              print(decodedJson);

                              if(decodedJson["success"]!=null && decodedJson["success"]==true){

                                invoiceMap = decodedJson["data"];



                                Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => DriverInvoicePdf(decodedJson["data"] )));
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
                                                  context, MaterialPageRoute(builder: (context) => DriverInvoice()));
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ).then((value) {
                                  if(value!=null && value=="closePage"){
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => DriverInvoice()));
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
                                                  context, MaterialPageRoute(builder: (context) => DriverInvoice()));
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ).then((value) {
                                  if(value!=null && value=="closePage"){
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => DriverInvoice()));
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
                            // Navigator.pushReplacement(
                            //     context, MaterialPageRoute(builder: (context) => CustomerPaymentList()));
                          },
                          label: 'CANCEL',
                          isDestructive: true,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          bottomSpacing: 4.0,
                        ),


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


            ],
          ),
        ),
      ),
    );
  }


}
