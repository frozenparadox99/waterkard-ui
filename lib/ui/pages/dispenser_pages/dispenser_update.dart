
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/deposite_pages/deposite_list.dart';
import 'package:waterkard/ui/pages/dispenser_pages/dispenser_list.dart';

import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:card_settings/card_settings.dart';



class DispenserUpdate extends StatefulWidget {
  @override
  _DispenserUpdateState createState() => _DispenserUpdateState();
}

class _DispenserUpdateState extends State<DispenserUpdate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _customerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _startDateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _endDateKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) => Scaffold(

    drawer: Sidebar(),
    appBar: AppBar(
      title: Text('Dispenser'),
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
            // await FirebaseAuth.instance.signOut();
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
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
                  child: Text("Customer Name", style: TextStyle(color: Colors.white, fontSize: 40),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("Dispensers: 3", style: TextStyle(color: Colors.white, fontSize: 18),),
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
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: CardSettings(
                          cardElevation: 0,

                          contentAlign: TextAlign.right,
                          children: <CardSettingsSection>[
                            CardSettingsSection(
                              header: CardSettingsHeader(
                                label: 'Edit Dispensers',
                                labelAlign: TextAlign.center,
                              ),
                              children: <CardSettingsWidget>[





                                CardSettingsListPicker(
                                  icon: Icon(Icons.person),
                                  key: _customerKey,
                                  label: 'Product',
                                  initialValue: 'Product 1',
                                  hintText: 'Select Product',
                                  options: <String>['Product 1', 'Product 2', 'Product 3', 'Product 4'],
                                  values: <String>['c1', 'c2','c3', 'c4'],
                                  onChanged: (value){
                                    // setState(() {
                                    //   paymentMethod = value;
                                    // });
                                  },
                                ),

                                CardSettingsText(
                                  icon: Icon(Icons.money),
                                  label: 'Quantity',
                                  hintText: 'Enter No. Of Dispensers',
                                ),





                                CardSettingsButton(
                                  onPressed: (){
                                    // Navigator.pushReplacement(
                                    //     context, MaterialPageRoute(builder: (context) => InvoicePdf()));
                                  },

                                  label: 'SAVE',
                                  backgroundColor: Color(0xFF80D8FF),
                                ),

                                CardSettingsButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => DispenserList()));
                                  },
                                  label: 'CANCEL',
                                  isDestructive: true,
                                  backgroundColor: Colors.redAccent,
                                  textColor: Colors.white,
                                  bottomSpacing: 4.0,
                                ),


                              ],
                            ),
                            // CardSettingsSection(
                            //
                            //   header: CardSettingsHeader(
                            //     label: 'Actions',
                            //   ),
                            //   children: <CardSettingsWidget>[
                            //     CardSettingsButton(
                            //
                            //       label: 'SAVE',
                            //       backgroundColor: Color(0xFF80D8FF),
                            //     ),
                            //     CardSettingsButton(
                            //       label: 'CANCEL',
                            //       isDestructive: true,
                            //       backgroundColor: Colors.red,
                            //       textColor: Colors.white,
                            //       bottomSpacing: 4.0,
                            //     )
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 400,),
                      SizedBox(height: 400,),

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




