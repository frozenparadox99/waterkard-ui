import 'package:flutter/material.dart';
import 'package:waterkard/services/api_services.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

class DriverLogin extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Color(0xFF4267B2),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: scrHeight * 0.40,
                padding: EdgeInsets.all(20),
                // alignment: Alignment.center,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: scrHeight * 0.60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    )),
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    _buildForm(),
                    InkWell(
                      onTap: (){
                        login(context);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: scrWidth * 0.85,
                        height: 75,
                        decoration: BoxDecoration(
                          color: Color(0xff5f69f8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'ProductSans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              maxLength: 10,
              textInputAction: TextInputAction.next,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Mobile Number cannot be empty';
                } else if (value.length != 10) {
                  return 'Mobile Number must be 10 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  counterText: ""
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login(BuildContext context) async{

    disableKeyboard(context);

    if(!_formKey.currentState.validate()) return;

    loadingDialogue(context: context);

    Map response = await ApiServices().driverLogin(
        phoneNumber: "+91${_phoneNumberController.text}",
        password: _passwordController.text
    );

    print(response);

    if(!response["success"]){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          response["message"],
        ),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    SharedPrefsService.saveDriverId(response["data"]["id"]);
    SharedPrefsService.saveDriverName(response["data"]["name"]);
    SharedPrefsService.saveDriverVendor(response["data"]["vendor"]);
    Navigator.pushNamedAndRemoveUntil(context, "/driverHomePage", (route) => false);

  }
}