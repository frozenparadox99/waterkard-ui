import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/invoice_pages/invoice_pdf.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

class SelectInvoice extends StatefulWidget {
  const SelectInvoice({Key key}) : super(key: key);

  @override
  _SelectInvoiceState createState() => _SelectInvoiceState();
}

class _SelectInvoiceState extends State<SelectInvoice> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _customerKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _startDateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _endDateKey = GlobalKey<FormState>();
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
          title: Text('Invoice'),
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
                        label: 'Generate Invoice',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[


                        CardSettingsDatePicker(
                          key: _startDateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'Start Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime(2020, 10, 10, 20, 30),

                        ),

                        CardSettingsDatePicker(
                          key: _endDateKey,
                          icon: Icon(Icons.calendar_today),
                          label: 'End Date',
                          dateFormat: DateFormat.yMMMMd(),
                          initialValue:  DateTime(2020, 10, 10, 20, 30),

                        ),


                        CardSettingsListPicker(
                          icon: Icon(Icons.person),
                          key: _customerKey,
                          label: 'Customer',
                          initialValue: 'Customer 1',
                          hintText: 'Select Customer',
                          options: <String>['Customer 1', 'Customer 2', 'Customer 3', 'Customer 4'],
                          values: <String>['c1', 'c2','c3', 'c4'],
                          onChanged: (value){
                            // setState(() {
                            //   paymentMethod = value;
                            // });
                          },
                        ),





                        CardSettingsButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => InvoicePdf()));
                          },

                          label: 'SAVE',
                          backgroundColor: Color(0xFF80D8FF),
                        ),

                        CardSettingsButton(
                          onPressed: (){
                            // Navigator.pushReplacement(
                            //     context, MaterialPageRoute(builder: (context) => CustomerPaymentList()));
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
