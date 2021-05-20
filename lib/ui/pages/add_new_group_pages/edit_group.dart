import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waterkard/ui/pages/add_new_group_pages/list_groups.dart';

import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';


class EditGroup extends StatefulWidget {
  const EditGroup({Key key}) : super(key: key);

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {

  String uid;

  String val1,val2,val3;

  List<String> availableGroups = [
    "Group 3", "Group 4", "Group 5"
  ];

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
        title: Text('Edit Group'),
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
                        // SizedBox(height: 80,),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Text("Group A", style: TextStyle(color: Colors.black, fontSize: 40),),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: Text("Total Customers: 200", style: TextStyle(color: Colors.black, fontSize: 18),),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 40,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: <Widget>[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Customer',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Change Group',
                                        style: TextStyle(fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                  rows:  <DataRow>[
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [

                                            Text('Customer 1'),
                                            Text('9823417892'),
                                          ],
                                        )),

                                        DataCell(DropdownButton(
                                          hint: Text("Change Group"),
                                          value: val1,
                                          onChanged: (newVal){
                                            setState(() {
                                              val1 = newVal;
                                            });
                                          },
                                          items: availableGroups.map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          )).toList(),
                                        )),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [

                                            Text('Customer 2'),
                                            Text('9823417892'),
                                          ],
                                        )),

                                        DataCell(DropdownButton(
                                          hint: Text("Change Group"),
                                          value: val2,
                                          onChanged: (newVal){
                                            setState(() {
                                              val2 = newVal;
                                            });
                                          },
                                          items: availableGroups.map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          )).toList(),
                                        )),
                                      ],
                                    ),
                                    DataRow(
                                      cells: <DataCell>[
                                        DataCell(Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [

                                            Text('Customer 3'),
                                            Text('9823417892'),
                                          ],
                                        )),

                                        DataCell(DropdownButton(
                                          hint: Text("Change Group"),
                                          value: val3,
                                          onChanged: (newVal){
                                            setState(() {
                                              val3 = newVal;
                                            });
                                          },
                                          items: availableGroups.map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          )).toList(),
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),



                            ],
                          ),
                        ),
                        SizedBox(height: 40,),

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
                                context, MaterialPageRoute(builder: (context) => ListGroups()));
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
}
