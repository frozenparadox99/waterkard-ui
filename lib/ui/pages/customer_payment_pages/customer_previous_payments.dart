import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/add_payment.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/edit_payment.dart';
import 'package:waterkard/ui/pages/my_products_pages/edit_product.dart';


import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';


class CustomerPreviousPayments extends StatefulWidget {
  const CustomerPreviousPayments({Key key}) : super(key: key);

  @override
  _CustomerPreviousPaymentsState createState() => _CustomerPreviousPaymentsState();
}

class _CustomerPreviousPaymentsState extends State<CustomerPreviousPayments> {

  String uid;

  String currentStateSelected;

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Payment'),
        actions: [
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
                                child: Text("Customer Name", style: TextStyle(color: Colors.black, fontSize: 32),),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: Text("Advance: Rs.500", style: TextStyle(color: Colors.black, fontSize: 18),),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 30,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 2.0,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'Date',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Paid Amount',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),


                                        Text(
                                          'Edit',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),
                                    PaymentRow(),





                                  ],
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
            fontSize: 12,
          ),
        ),
        Text(
          'Rs. 500',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),


       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           SizedBox(width: 25.0,),
           IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditPayment()),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 18,
                ),
              ),
         ],
       ),


        Center(
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}
