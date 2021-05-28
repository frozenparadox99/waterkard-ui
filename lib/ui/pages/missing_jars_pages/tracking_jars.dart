import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/vendor_home_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

TextStyle headingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700
);
TextStyle contentStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'sfpro'
);
LinearGradient gradientStyle = LinearGradient(
    colors: [Color(0xfff3953b), Color(0xffe57509)],
    stops: [0,1],
    begin: Alignment.topCenter
);

class TrackingJars extends StatefulWidget {
  @override
  _TrackingJarsState createState() => _TrackingJarsState();
}

class _TrackingJarsState extends State<TrackingJars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Missing Jars'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => AddProduct()));
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
              // await FirebaseAuth.instance.signOut();
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Number 1001", style: headingStyle,),
              Text("Driver Assigned: Driver 1", style: contentStyle.copyWith(
                  color: Colors.grey,
                  fontSize: 16
              ),),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 1,
                color: Colors.grey,
              ),
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 13, top: 50),
                    width: 4,
                    height: 400,
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      statusWidget('shipped', "Confirmed ", true),
                      statusWidget('onBoard2', "Loaded Jars: 30", false),
                      statusWidget('shipped', "Delivered Jars: 15", false),
                      statusWidget('servicesImg', "Unloaded Jars: 15", false),
                      statusWidget('shipped', "Missing Jars: 0", false),
                    ],
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                height: 1,
                color: Colors.grey,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => VendorHomePage()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: Color(0xFF5F6AF8),
                          )
                      ),
                      child: Text("Back", style: contentStyle.copyWith(
                        color: Color(0xFF5F6AF8),
                      ),),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                      color: Color(0xFF5F6AF8),

                    ),
                    child: Text("View Order", style: contentStyle.copyWith(
                        color: Colors.white
                    ),),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),

    );
  }
  Container statusWidget(String img, String status, bool isActive)
  {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,

            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isActive) ? Color(0xFF5F6AF8) : Colors.white,
                border: Border.all(
                    color: (isActive) ? Colors.transparent : Color(0xFF5F6AF8),
                    width: 3
                )
            ),
          ),
          SizedBox(width: 50,),
          Column(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/$img.png"),
                        fit: BoxFit.contain
                    )
                ),
              ),

            ],
          ),
          SizedBox(width: 50,),
          Text(status, style: contentStyle.copyWith(
              color: (isActive) ? Color(0xFF5F6AF8) : Colors.black
          ),)
        ],
      ),
    );
  }
}