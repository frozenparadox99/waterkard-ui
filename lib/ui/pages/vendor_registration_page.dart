import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

class VendorRegistrationPage extends StatefulWidget {
  const VendorRegistrationPage({Key key}) : super(key: key);

  @override
  _VendorRegistrationPageState createState() => _VendorRegistrationPageState();
}

class _VendorRegistrationPageState extends State<VendorRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _fullBrandNameController = TextEditingController();
  final  _statesOfIndia = [
    {
      "display":"Maharashtra",
      "value":"Maharashtra",
    },
    {
      "display":"Karnataka",
      "value":"Karnataka",
    },
    {
      "display":"Uttar Pradesh",
      "value":"Uttar Pradesh",
    },
    ];

  String currentStateSelected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStateSelected = "";
  }

  @override
  Widget build(BuildContext context) {
    var scrWidth = MediaQuery.of(context).size.width;
    var scrHeight = MediaQuery.of(context).size.height;


    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 40),
                      child: Text(
                        'Register Here',
                        style: TextStyle(
                          fontFamily: 'Cardo',
                          fontSize: 35,
                          color: Color(0xff0C2551),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      //
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, top: 5),
                      child: Text(
                        'Yes I am a Vendor',
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(

                      horizontal: 10.0,
                    ),
                    child: _buildForm(),
                  ),

                  // Text(
                  //   "Creating an account means you're okay with\nour Terms of Service and Privacy Policy",
                  //   style: TextStyle(
                  //     fontFamily: 'Product Sans',
                  //     fontSize: 10,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xff8f9db5).withOpacity(0.45),
                  //   ),
                  //   //
                  // ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()) {
                        print(_phoneNumberController.text);
                        print(_brandController.text);
                        print(_fullBrandNameController.text);
                        print(currentStateSelected);
                      }
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
                          'Create an Account',
                          style: TextStyle(
                            fontFamily: 'ProductSans',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff8f9db5).withOpacity(0.45),
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff5f69f8),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              ClipPath(
                clipper: OuterClippedPart(),
                child: Container(

                  color: Color(0xffbbb7f7),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
              //
              ClipPath(
                clipper: InnerClippedPart(),
                child: Container(
                  color: Color(0xff5f69f8),
                  width: scrWidth,
                  height: scrHeight,
                ),
              ),
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
              controller: _fullBrandNameController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Full Business Name cannot be empty';
                } else if (value.length < 3) {
                  return 'Full Business Name must be at least 3 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Full Business Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _brandController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Brand cannot be empty';
                } else if (value.length < 3) {
                  return 'Brand must be at least 3 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Brand',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropDownFormField(
              validator: (dynamic value){
                if(value == null){
                  return 'Country cannot be empty';
                }
                return null;
              },
              titleText: 'Country',
              value: currentStateSelected,
              onSaved: (value) {
                setState(() {
                  currentStateSelected = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  currentStateSelected= value;
                });
              },
              dataSource: _statesOfIndia,
              textField: 'display',
              valueField: 'value',

            ),
          ),


        ],
      ),
    );
  }
}

class OuterClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height / 4);
    //
    path.cubicTo(size.width * 0.55, size.height * 0.16, size.width * 0.85,
        size.height * 0.05, size.width / 2, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class InnerClippedPart extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    //
    path.moveTo(size.width * 0.7, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    //
    path.quadraticBezierTo(
        size.width * 0.8, size.height * 0.11, size.width * 0.7, 0);

    //
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}