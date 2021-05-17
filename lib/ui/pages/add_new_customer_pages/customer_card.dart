import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

class CustomerCard extends StatefulWidget {
  const CustomerCard({Key key}) : super(key: key);

  @override
  _CustomerCardState createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _typeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _groupKey = GlobalKey<FormState>();
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
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: CardSettings(
          contentAlign: TextAlign.right,
          children: <CardSettingsSection>[
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Add New Customer',
                labelAlign: TextAlign.center,
              ),
              children: <CardSettingsWidget>[
                CardSettingsText(
                  icon: Icon(Icons.person_add_alt_1),
                  label: 'Name',
                  hintText: 'Enter Customer Name',
                ),
                CardSettingsPhone(
                  icon: Icon(Icons.phone_android),
                  hintText: 'Enter Phone Number',
                  label: 'Mobile',
                ),
                CardSettingsListPicker(
                  icon: Icon(Icons.location_city_sharp),
                  key: _typeKey,
                  label: 'City',
                  initialValue: 'Mumbai',
                  hintText: 'Select One',
                  options: <String>['Mumbai', 'Pune', 'Noida', 'Bangalore'],
                  values: <String>['E', 'U', 'P', 'A'],
                ),
                CardSettingsText(
                  icon: Icon(Icons.location_on),
                  label: 'Address',
                  hintText: 'Enter Customer Address',
                ),
                CardSettingsText(
                  icon: Icon(Icons.person_pin_circle),
                  label: 'Pincode',
                  hintText: 'Enter Customer Pincode',
                ),
                CardSettingsEmail(
                  icon: Icon(Icons.person),
                ),
                CardSettingsListPicker(
                  icon: Icon(Icons.group),
                  key: _groupKey,
                  label: 'Group',
                  initialValue: 'Default',
                  hintText: 'Select Group',
                  options: <String>['Default', 'Group 1', 'Group 2', 'Group 3'],
                  values: <String>['E', 'U', 'P', 'A'],
                ),
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
              ],
            ),
            CardSettingsSection(
              header: CardSettingsHeader(
                label: 'Actions',
              ),
              children: <CardSettingsWidget>[
                CardSettingsButton(
                  onPressed: () {},
                  label: 'SAVE',
                  backgroundColor: Color(0xFF80D8FF),
                ),
                CardSettingsButton(
                  onPressed: () {},
                  label: 'RESET',
                  isDestructive: true,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  bottomSpacing: 4.0,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
