import 'dart:convert';
import 'package:http/http.dart' as httpp;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/api/constants.dart';


import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:waterkard/ui/widgets/Spinner.dart';

class TransactionModel {
  String date;

  String amount;

  String product;

  String mode;

  TransactionModel(this.date, this.amount,
      this.product, this.mode);
}


class CustomerPreviousPayments extends StatefulWidget {
  String customer;
  String name;
  CustomerPreviousPayments(this.customer,this.name);

  @override
  _CustomerPreviousPaymentsState createState() => _CustomerPreviousPaymentsState();
}

class _CustomerPreviousPaymentsState extends State<CustomerPreviousPayments> {

  // String uid;

  String currentStateSelected;
  bool isLoading = false;
  List<TransactionModel> allCustomersForVendor = [];

  get http => null;

  void initState() {
    // TODO: implement initState
    super.initState();
    // uid = FirebaseAuth.instance.currentUser.uid;
    getAllCustomerPayments();
  }

  void getAllCustomerPayments () async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);
    print("Customer: ${widget.customer}");

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/customer/payment?vendor=$id&customer=${widget.customer}";
      print(apiURL);
      var response = await httpp.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["customerPayments"]!=null){
        List<dynamic> receivedCustomers = decodedJson["data"]["customerPayments"];
        List<dynamic> formatted = receivedCustomers.map((e) => {
          "date":new DateFormat("yyyy-MM-dd").parse(e["date"]),
          "amount":e["amount"],
          "product": e["product"],
          "mode": e["mode"],
        }).toList();



        setState(() {
          allCustomersForVendor = formatted.map((item) => TransactionModel(
              DateFormat("yyyy-MM-dd").format(item['date']),
              "${item['amount']}",
              "${item['product']}",
              item["mode"]
          ))
              .toList();
          isLoading = false;
        });

      }

    }
  }


  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Spinner();
    }
    return  Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Payment'),
        actions: [
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
              // await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(

          color: Color(0xFF5F6AF8),
        ),
        child: Column(
          children: <Widget>[


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
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text("${widget.name}", style: TextStyle(color: Colors.black, fontSize: 32),),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[
                              // Card(
                              //   elevation: 2.0,
                              //   child: Column(
                              //     children: [
                              //       SizedBox(
                              //         height: 10,
                              //       ),
                              //       Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //         children: [
                              //           Text(
                              //             'Date',
                              //             style: TextStyle(
                              //               color: Colors.black,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //           Text(
                              //             'Amount',
                              //             style: TextStyle(
                              //               color: Colors.black,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //
                              //
                              //           Text(
                              //             'Product',
                              //             style: TextStyle(
                              //               color: Colors.black,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //           Text(
                              //             'Mode',
                              //             style: TextStyle(
                              //               color: Colors.black,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //       PaymentRow(),
                              //
                              //
                              //
                              //
                              //
                              //     ],
                              //   ),
                              // ),

                              DataTable(
                                columns: [
                                  DataColumn(label: Text(
                                      'Date',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                  )),
                                  DataColumn(label: Text(
                                      'Amount',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                  )),
                                  DataColumn(label: Text(
                                      'Product',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                  )),
                                  DataColumn(label: Text(
                                      'Mode',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                  )),
                                ],
                                rows: [
                                  ...allCustomersForVendor.map((e) =>
                                      buildDataRow(e.date,e.amount,e.product,e.mode)
                                  ).toList(),

                                ],
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
    );
  }

  DataRow buildDataRow(date,amount,product,mode) {
    return DataRow(cells: [
                                  DataCell(Text('$date')),
                                  DataCell(Text('$amount')),
                                  DataCell(Text('$product')),
                                  DataCell(Text('$mode')),
                                ]);
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
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class PaymentRow extends StatelessWidget {
  const PaymentRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '17-05-2021',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        Text(
          'Rs. 500',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),

        // Text(
        //   '18L',
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 12,
        //   ),
        // ),
        // Text(
        //   'Cash',
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 12,
        //   ),
        // ),


       // Row(
       //   mainAxisAlignment: MainAxisAlignment.center,
       //   children: [
       //     SizedBox(width: 25.0,),
       //     IconButton(
       //          onPressed: () {
       //            Navigator.push(
       //              context,
       //              MaterialPageRoute(
       //                  builder: (context) => EditPayment()),
       //            );
       //          },
       //          icon: Icon(
       //            Icons.edit,
       //            color: Colors.black,
       //            size: 18,
       //          ),
       //        ),
       //   ],
       // ),

        // Center(
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.delete,
        //       color: Colors.red,
        //       size: 18,
        //     ),
        //   ),
        // ),
        Center(
          child:  Text(
            '18L',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),

        Center(
          child:  Text(
            'Cash',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
