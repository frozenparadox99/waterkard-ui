import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/driver_payment_list.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

class AddDriverPayment extends StatefulWidget {
  const AddDriverPayment({Key key}) : super(key: key);

  @override
  _AddDriverPaymentState createState() => _AddDriverPaymentState();
}

class _AddDriverPaymentState extends State<AddDriverPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _driverKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _paymentMethodKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  String uid;
  String paymentMethod;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Sidebar(),
        appBar: AppBar(
          title: Text('My Products'),
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 50.0,),
              Form(
                key: _formKey,
                child: CardSettings(

                  contentAlign: TextAlign.right,
                  children: <CardSettingsSection>[
                    CardSettingsSection(
                      header: CardSettingsHeader(
                        label: 'Add Payment',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[

                        CardSettingsListPicker(
                          icon: Icon(Icons.person),
                          key: _driverKey,
                          label: 'Driver',
                          initialValue: 'Driver 1',
                          hintText: 'Select Driver',
                          options: <String>['Driver 1', 'Driver 2'],
                          values: <String>['E', 'U'],
                        ),
                        CardSettingsDatePicker(
                          key: _dateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime(2020, 10, 10, 20, 30),

                        ),
                        CardSettingsText(
                          icon: Icon(Icons.money),
                          label: 'Amount',
                          hintText: 'Enter Amount Here',
                        ),

                        CardSettingsListPicker(
                          icon: Icon(Icons.credit_card_sharp),
                          key: _paymentMethodKey,
                          label: 'Payment',
                          initialValue: 'Cash',
                          hintText: 'Select Method',
                          options: <String>['Cash', 'Online', 'Cheque', 'Other'],
                          values: <String>['cash', 'online','cheque', 'Other'],
                          onChanged: (value){
                            setState(() {
                              paymentMethod = value;
                            });
                          },
                        ),

                        paymentMethod == "cash"?CardSettingsText(
                          icon: Icon(Icons.money),
                          label: 'Amount',
                          hintText: 'Enter Amount Here',
                        ): paymentMethod=="online"?CardSettingsText(
                          icon: Icon(Icons.send_to_mobile),
                          label: 'App',
                          hintText: 'Enter App Name',
                        ): paymentMethod=="cheque"?CardSettingsText(
                          icon: Icon(Icons.money),
                          label: 'Cheque',
                          hintText: 'Enter Cheque Number',
                        ):CardSettingsText(
                          icon: Icon(Icons.money),
                          label: 'Mode',
                          hintText: 'Enter Payment Mode',
                        ),



                        CardSettingsButton(

                          label: 'SAVE',
                          backgroundColor: Color(0xFF80D8FF),
                        ),

                        CardSettingsButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => DriverPaymentList()));
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

              SizedBox(height: 20.0,),


            ],
          ),
        ),
      ),
    );
  }


}
