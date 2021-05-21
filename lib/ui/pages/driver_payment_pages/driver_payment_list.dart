import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/add_driver_payment.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/driver_previous_payments.dart';



import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';


class DriverPaymentList extends StatefulWidget {
  const DriverPaymentList({Key key}) : super(key: key);

  @override
  _DriverPaymentListState createState() => _DriverPaymentListState();
}

class _DriverPaymentListState extends State<DriverPaymentList> {

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
                    child: Text("Driver Payment", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("List of Drivers", style: TextStyle(color: Colors.white, fontSize: 18),),
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
                                            text: 'Driver 1',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '\nCustomers: 40',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 80,),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle),
                                          tooltip: 'Add',
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => AddDriverPayment()));
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          tooltip: 'Edit',
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => DriverPreviousPayments()));
                                          },
                                        ),
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          _iconBuilder("Today's\nCollection", '500'),
                                          _iconBuilder("Received\nCollection", '1000'),
                                          _iconBuilder("Balance\nCollection", '200'),
                                          _iconBuilder("Customer\nBalance", '900'),

                                        ],
                                      ),
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
                                            text: 'Driver 2',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '\nCustomers: 50',
                                                style: TextStyle(
                                                  color: Colors.black45,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 80,),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle),
                                          tooltip: 'Add',
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => AddDriverPayment()));
                                          },
                                        ),

                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          tooltip: 'Edit',
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                                context, MaterialPageRoute(builder: (context) => DriverPreviousPayments()));
                                          },
                                        ),
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          _iconBuilder("Today's\nCollection", '500'),
                                          _iconBuilder("Received\nCollection", '1000'),
                                          _iconBuilder("Balance\nCollection", '200'),
                                          _iconBuilder("Customer\nBalance", '900'),

                                        ],
                                      ),
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

  Container _iconBuilder(heading, title) {
    return Container(
      // decoration: BoxDecoration(
      //     border: Border(
      //       left: BorderSide(color: Colors.grey),
      //       right: BorderSide(color: Colors.grey),
      //     ),
      // ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            heading,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "Rs.$title",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
