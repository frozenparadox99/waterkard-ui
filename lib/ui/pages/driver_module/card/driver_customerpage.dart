import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

class DriverCustomerProductCard extends StatefulWidget {
  const DriverCustomerProductCard({Key key}) : super(key: key);

  @override
  _DriverCustomerProductCardState createState() =>
      _DriverCustomerProductCardState();
}

class _DriverCustomerProductCardState extends State<DriverCustomerProductCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _productKey = GlobalKey<FormState>();
  String uid;

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
          title: Text('Cards'),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: CardSettings(
                  contentAlign: TextAlign.right,
                  children: <CardSettingsSection>[
                    CardSettingsSection(
                      header: CardSettingsHeader(
                        label: 'Mr. Shivraj Patil',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[
                        CardSettingsListPicker(
                          icon: Icon(Icons.shopping_cart_outlined),
                          key: _productKey,
                          label: 'Product',
                          initialValue: '18 Litre Jar',
                          hintText: 'Select Jar',
                          options: <String>['18 L Jar', '20 L Jar'],
                          values: <String>['E', 'U'],
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.money),
                          label: 'Rate',
                          hintText: 'Enter Rate Of Jar',
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.water_damage),
                          label: 'Balance',
                          hintText: 'Enter the number of previous jars',
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.settings_display),
                          label: 'Dispensers',
                          hintText: 'Enter Dispensers',
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.credit_card),
                          label: 'Deposit',
                          hintText: 'Enter Customer Deposit',
                        ),
                        CardSettingsButton(
                          label: 'SAVE',
                          backgroundColor: Color(0xFF80D8FF),
                        ),
                        CardSettingsButton(
                          label: 'CANCEL',
                          isDestructive: true,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                          bottomSpacing: 4.0,
                        )
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
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: Text(
                'Products',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              // SizedBox(height: 20.0,),
              // DataTable(
              //   columns: [
              //     DataColumn(label: Text(
              //         'ID',
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              //     )),
              //     DataColumn(label: Text(
              //         'Name',
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              //     )),
              //     DataColumn(label: Text(
              //         'Price',
              //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              //     )),
              //   ],
              //   rows: [
              //     DataRow(cells: [
              //       DataCell(Text('1')),
              //       DataCell(Text('18L Cool Jar')),
              //       DataCell(Text('Rs.50')),
              //     ]),
              //     DataRow(cells: [
              //       DataCell(Text('2')),
              //       DataCell(Text('20L Jar')),
              //       DataCell(Text('Rs.60')),
              //     ]),
              //
              //
              //   ],
              // ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
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
                          backgroundImage:
                              AssetImage("assets/product-card-jar.jpg"),
                          radius: 36.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '18L Cool Jar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\nPrice: Rs.50',
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
                        _iconBuilder(Icons.edit, 'Edit'),
                        _iconBuilder(Icons.cancel, 'Delete'),
                        _iconBuilder(Icons.person, 'Customer'),
                        _iconBuilder(Icons.directions_car, 'Driver'),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
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
                          backgroundImage:
                              AssetImage("assets/onboarding-image-3.jpg"),
                          radius: 36.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '20L Bottle Jar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\nPrice: Rs.50',
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
                        _iconBuilder(Icons.edit, 'Edit'),
                        _iconBuilder(Icons.cancel, 'Delete'),
                        _iconBuilder(Icons.person, 'Customer'),
                        _iconBuilder(Icons.directions_car, 'Driver'),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
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