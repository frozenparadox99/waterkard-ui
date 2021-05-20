import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/my_products_pages/all_products.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:card_settings/card_settings.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key key}) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _productKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _defaultProductKey = GlobalKey<FormState>();
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
          title: Text('My Products'),
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
                        label: 'Edit Product',
                        labelAlign: TextAlign.center,
                      ),
                      children: <CardSettingsWidget>[

                        CardSettingsListPicker(
                          icon: Icon(Icons.shopping_cart_outlined),
                          key: _productKey,
                          label: 'Unit',
                          initialValue: '18 Litre Jar',
                          hintText: 'Select Jar',
                          options: <String>['18 L Jar', '20 L Jar'],
                          values: <String>['E', 'U'],
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.add_shopping_cart_outlined),
                          label: 'Name',
                          hintText: 'Enter product name',
                        ),
                        CardSettingsText(
                          icon: Icon(Icons.money),
                          label: 'Rate',
                          hintText: 'Enter Rate Of Jar',
                        ),
                        CardSettingsSwitch(
                          icon: Icon(Icons.ad_units),
                          key: _defaultProductKey,
                          label: 'Default',
                          initialValue: false,

                        ),


                        CardSettingsButton(

                          label: 'SAVE',
                          backgroundColor: Color(0xFF80D8FF),
                        ),

                        CardSettingsButton(
                          onPressed: (){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => AllProducts()));
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
