import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/add_payment.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_previous_payments.dart';
import 'package:waterkard/ui/pages/my_products_pages/edit_product.dart';


import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';


class CustomerPaymentList extends StatefulWidget {
  const CustomerPaymentList({Key key}) : super(key: key);

  @override
  _CustomerPaymentListState createState() => _CustomerPaymentListState();
}

class _CustomerPaymentListState extends State<CustomerPaymentList> {

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
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("Customer Payment", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("List of Customers", style: TextStyle(color: Colors.white, fontSize: 18),),
                  )
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
                                padding: EdgeInsets.symmetric(vertical: 14.0),
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
                                          backgroundImage: AssetImage("assets/profile_user.jpg"),
                                          radius: 28.0,
                                        ),
                                        SizedBox(width: 10,),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Mr. Shivraj Patil',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '\nAdvance: Rs.500',
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
                                        InkWell(onTap: (){
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => AddPayment()));
                                        },child: _iconBuilder(Icons.add_circle, 'Add Payment')),
                                        _iconBuilder(Icons.notifications, 'Request'),
                                        InkWell(onTap: (){
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => CustomerPreviousPayments()));
                                        }
                                            ,child: _iconBuilder(Icons.edit, 'Edit')),
                                        _iconBuilder(Icons.cancel, 'Delete'),

                                      ],
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(vertical: 14.0),
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
                                          backgroundImage: AssetImage("assets/profile_user.jpg"),
                                          radius: 28.0,
                                        ),
                                        SizedBox(width: 10,),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Mr. Shivraj Patil',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '\nAdvance: Rs.500',
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
                                        _iconBuilder(Icons.add_circle, 'Add Payment'),
                                        _iconBuilder(Icons.notifications, 'Request'),
                                        InkWell(onTap: (){
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => CustomerPreviousPayments()));
                                        }
                                            ,child: _iconBuilder(Icons.edit, 'Edit')),
                                        _iconBuilder(Icons.cancel, 'Delete'),

                                      ],
                                    )
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
