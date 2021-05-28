import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/ui/pages/dispenser_pages/dispenser_update.dart';
import 'package:waterkard/ui/pages/my_products_pages/add_product.dart';
import 'package:waterkard/ui/pages/my_products_pages/edit_product.dart';


import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';


class DispenserList extends StatefulWidget {
  const DispenserList({Key key}) : super(key: key);

  @override
  _DispenserListState createState() => _DispenserListState();
}

class _DispenserListState extends State<DispenserList> {

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
        title: Text('Dispensers'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddProduct()));
            },
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
                    child: Text("Dispenser List", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("Total = 150", style: TextStyle(color: Colors.white, fontSize: 18),),
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

                        SizedBox(height: 20,),
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
                                        // CircleAvatar(
                                        //   backgroundColor: Color(0xFFD9D9D9),
                                        //   backgroundImage: AssetImage("assets/product-card-jar.jpg"),
                                        //   radius: 36.0,
                                        // ),
                                        SizedBox(width: 36,),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Customer 1',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '\nRowaale Bottle Jar',
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
                                      height: 4.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        SizedBox(width: 36,),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Quantity: 1',
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,

                                            ),

                                          ),
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
                                      indent: 20,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        InkWell(onTap: (){
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => DispenserUpdate()));
                                        }
                                            ,child: _iconBuilder(Icons.edit, 'Edit')),
                                        _iconBuilder(Icons.cancel, 'Delete'),
                                        _iconBuilder(Icons.person, 'Customer'),
                                        _iconBuilder(Icons.directions_car, 'Driver'),
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
                                        // CircleAvatar(
                                        //   backgroundColor: Color(0xFFD9D9D9),
                                        //   backgroundImage: AssetImage("assets/onboarding-image-3.jpg"),
                                        //   radius: 36.0,
                                        // ),
                                        SizedBox(width: 36,),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Customer 2',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              height: 1.5,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '\nRowaale Bottle Jar',
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
                                      height: 4.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        SizedBox(width: 36,),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Quantity: 3',
                                            style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,

                                            ),

                                          ),
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
                                      indent: 20,
                                    ),
                                    SizedBox(
                                      height: 8.0,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        InkWell(onTap: (){
                                          Navigator.pushReplacement(
                                              context, MaterialPageRoute(builder: (context) => DispenserUpdate()));

                                        },child: _iconBuilder(Icons.edit, 'Edit')),
                                        _iconBuilder(Icons.cancel, 'Delete'),
                                        _iconBuilder(Icons.person, 'Customer'),
                                        _iconBuilder(Icons.directions_car, 'Driver'),
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
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
