import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_homepage.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_jar_and_payments.dart';
import 'package:waterkard/ui/pages/transactions_pages/daily_transactions_list.dart';
import 'package:waterkard/ui/widgets/shared_button.dart';
import 'package:waterkard/utils.dart';

import 'dialogue_box.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class NewCustomerCard extends StatelessWidget {
  final Map customerMap;
  NewCustomerCard({@required this.customerMap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: (){
        print(customerMap["_id"]);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>DailyTransactionList(customerId: customerMap["_id"]))
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: colorLightBlue,
                  blurRadius: 10,
                  spreadRadius: 2
              )
            ]
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.call_sharp,
                        color: colorLightBlue,
                        size: 30,
                      ),
                      onPressed: (){
                        print(customerMap);
                        call(customerMap["mobileNumber"]);
                      }
                  ),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customerMap["name"],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            customerMap["group"],
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colorLightBlue
                            ),
                          ),
                        ],
                      )
                  ),
                  InkWell(
                    onTap: (){
                      Map address = customerMap["address"];
                      List coordinates = address["coordinates"];
                      navigateTo(coordinates.first, coordinates.last);
                    },
                    child: Icon(
                      Icons.send_rounded,
                      color: colorLightBlue,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DriverJarAndPaymentPage(
                                  customerMap["_id"], SharedPrefsService.getDriverId(),
                                  customerMap["mobileNumber"].split("+91")[1],)));
                    },
                    child: Icon(
                      Icons.add_circle,
                      color: colorLightBlue,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                    onTap: (){
                      if(customerMap["status"]=="completed" || customerMap["status"]=="skipped")
                      {
                        return;
                      }

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
                              "Are you sure you want to skip?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                  text:"Yes",
                                  onPressed: () async {
                                    DateTime date = DateTime.now() ;
                                    String newDate = "${date.day}/${date.month}/${date.year}";


                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    var vendId = prefs.getString("driverVendor");
                                    var drivId = prefs.getString("driverId");
                                    // print(id);

                                    if(vendId!=null){
                                      // print(id);
                                      print(newDate);
                                      // print(customerMap["driver"]);
                                      print(customerMap["_id"]);
                                      String apiURL =
                                          "$API_BASE_URL/api/v1/vendor/driver/add-transaction";
                                      var response = await http.post(Uri.parse(apiURL),
                                          headers: <String, String>{
                                            'Content-Type': 'application/json; charset=UTF-8',
                                          },
                                          body:jsonEncode( <String, dynamic>{
                                            "vendor":vendId,
                                            "date":newDate,
                                            "driver":drivId,
                                            "customer":customerMap["_id"],
                                            "status":"skipped"
                                          }));
                                      var body = response.body;

                                      var decodedJson = jsonDecode(body);

                                      print(body);
                                      print(decodedJson);
                                      if(decodedJson["success"]!=null && decodedJson["success"]==true){
                                        Navigator.pushReplacement(
                                            context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                                      }
                                    }



                                  },
                                  // height: 40,
                                  // paddingHorizontal: 15,
                                  // textSize: 18,
                                ),
                                MaterialButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: 18
                                    ),
                                  ),
                                  onPressed: (){
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ).then((value) {
                        if(value!=null && value=="closePage"){
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => DriverHomePage()));
                        }
                      });

                    },
                    child: Container(
                      height: 27,
                      width: 27,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: customerMap["status"]=="completed"?Colors.green: customerMap["status"]=="skipped"?Colors.red :Colors.yellow, width: 3)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
              height: 1,
            ),
            SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sold",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        customerMap['totalSold'].toString(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Empty",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        customerMap['totalEmptyCollected'].toString(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Balance",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        customerMap['totalBalance'].toString(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  VerticalDivider(
                    color: Colors.black,
                    thickness: 1,
                    width: 1,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        int.parse("${customerMap['balancePayment'].toString()}")>0?"Balance\nPayment":"Advance\nPayment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        int.parse("${customerMap['balancePayment'].toString()}")>0?" ${customerMap['balancePayment'].toString()}":" ${int.parse("${customerMap['balancePayment'].toString()}")*-1}",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: int.parse("${customerMap['balancePayment'].toString()}")>0?Colors.red:Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}