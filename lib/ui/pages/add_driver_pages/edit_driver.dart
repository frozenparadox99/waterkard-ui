import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:waterkard/ui/pages/add_driver_pages/all_drivers.dart';

import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';


class EditDriver extends StatefulWidget {
  const EditDriver({Key key}) : super(key: key);

  @override
  _EditDriverState createState() => _EditDriverState();
}

class _EditDriverState extends State<EditDriver> {

  String uid;
  final _groupNames = [
    {
      "display": "Group 1",
      "value": "G1",
    },
    {
      "display": "Group 2",
      "value": "G2",
    },
    {
      "display": "Group 3",
      "value": "G3",
    },
  ];

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
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: ()  {},
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
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text("Edit Driver", style: TextStyle(color: Colors.white, fontSize: 40),),
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Text("You can edit the group as well", style: TextStyle(color: Colors.white, fontSize: 18),),
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
                        SizedBox(height: 40,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[200])
                                    )
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "Name of Driver",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[200])
                                    )
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "Mobile Number",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,


                                ),
                                child: DropDownFormField(
                                  validator: (dynamic value) {
                                    if (value == null) {
                                      return 'State cannot be empty';
                                    }
                                    return null;
                                  },
                                  titleText: 'Assign Group',
                                  value: currentStateSelected,
                                  onSaved: (value) {
                                    setState(() {
                                      currentStateSelected = value;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      currentStateSelected = value;
                                    });
                                  },
                                  dataSource: _groupNames,
                                  textField: 'display',
                                  valueField: 'value',
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: Colors.grey[200])
                                    )
                                ),

                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),

                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                            color: Color(0xFF5F6AF8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text("Submit",style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),),
                          ),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => AllDrivers()));
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              color: Color(0xffFF2E63),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text("Cancel",style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),

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
}
