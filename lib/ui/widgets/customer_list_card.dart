import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/api/constants.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/cards_customer/jarAndPayment.dart';
import 'package:waterkard/ui/pages/cards_customer/newCustomerCards.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_jar_and_payments.dart';
import 'package:waterkard/ui/pages/my_customers/edit_customer.dart';
import 'package:waterkard/ui/pages/transactions_pages/daily_transactions_list.dart';
import 'package:waterkard/ui/pages/transactions_pages/vendor_daily_transactions.dart';
import 'package:waterkard/ui/widgets/shared_button.dart';
import 'package:waterkard/utils.dart';
import 'package:waterkard/ui/pages/map_views/show_location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'dialogue_box.dart';


class CustomerListCardWidget extends StatelessWidget {
  final Map customerMap;
  CustomerListCardWidget({@required this.customerMap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: (){

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
                    onTap: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setInt("balance", customerMap["totalBalance"]);

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditCustomer(customerMap["_id"])));
                    },
                    child: Icon(
                      Icons.edit,
                      color: colorLightBlue,
                      size: 30,
                    ),
                  ),
                  SizedBox(width: 5,),
                  InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ProductCard(customerMap["_id"])));
                      },
                      child: Icon(Icons.shop)),

                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}