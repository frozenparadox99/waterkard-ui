import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/vendor_home_page.dart';
import 'package:waterkard/ui/pages/vendor_otp_page.dart';

class VendorLoginPage extends StatefulWidget {
  const VendorLoginPage({Key key}) : super(key: key);

  @override
  _VendorLoginPageState createState() => _VendorLoginPageState();
}

class _VendorLoginPageState extends State<VendorLoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User user;
  TextEditingController _controller = TextEditingController();


  @override
  void initState() {

    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    User _user = _firebaseAuth.currentUser;
    setState(() {
      user = _user;

    });
  }


  @override
  Widget build(BuildContext context) {
    print(user);
    return user!=null ? VendorHomePage():
    Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  'Phone Authentication',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+91'),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            )
          ]),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => VendorOtpPage(_controller.text)));

              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
