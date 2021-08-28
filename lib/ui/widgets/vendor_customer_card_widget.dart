import 'package:flutter/material.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/product_card.dart';
import 'package:waterkard/ui/pages/cards_customer/jarAndPayment.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_jar_and_payments.dart';
import 'package:waterkard/ui/pages/transactions_pages/daily_transactions_list.dart';
import 'package:waterkard/ui/pages/transactions_pages/vendor_daily_transactions.dart';
import 'package:waterkard/utils.dart';
import 'package:waterkard/ui/pages/map_views/show_location.dart';


class VendorCustomerCard extends StatelessWidget {
  final Map customerMap;
  VendorCustomerCard({@required this.customerMap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: (){
        print(customerMap["_id"]);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>VendorDailyTransactionList(customerId: customerMap["_id"]))
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowLocationScreen(customerMap["address"]["coordinates"][0],customerMap["address"]["coordinates"][1])));
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
                              builder: (context) => JarAndPaymentPage(customerMap["_id"],customerMap["driver"],customerMap["mobileNumber"].split("+91")[1])));
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
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => ProductCard(customerMap["_id"])));
                      },
                      child: Icon(Icons.shop)),
                  // InkWell(
                  //   onTap: (){
                  //
                  //   },
                  //   child: Container(
                  //     height: 27,
                  //     width: 27,
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         border: Border.all(color: Colors.red, width: 3)
                  //     ),
                  //   ),
                  // ),
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
                        "Balance\nPayment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        customerMap['totalDeposit'].toString(),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold
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