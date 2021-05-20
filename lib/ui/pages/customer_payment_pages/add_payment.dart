import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _customerKey = GlobalKey<FormState>();
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
                          key: _customerKey,
                          label: 'Customer',
                          initialValue: 'Customer 1',
                          hintText: 'Select Customer',
                          options: <String>['Customer 1', 'Customer 2'],
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
                                context, MaterialPageRoute(builder: (context) => CustomerPaymentList()));
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
