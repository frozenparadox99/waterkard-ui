import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:waterkard/ui/pages/vendor_details_pages/vendor_get_details.dart';
import 'package:waterkard/ui/pages/vendor_registration_pages/stock_details.dart';

class GeneralDetailsPage extends StatefulWidget {
  const GeneralDetailsPage({Key key}) : super(key: key);

  @override
  _GeneralDetailsPageState createState() => _GeneralDetailsPageState();
}

class _GeneralDetailsPageState extends State<GeneralDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _brandController = TextEditingController();
  final _fullBrandNameController = TextEditingController();
  final _vendorNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();

  final _statesOfIndia = [
    {
      "display": "Maharashtra",
      "value": "Maharashtra",
    },
    {
      "display": "Karnataka",
      "value": "Karnataka",
    },
    {
      "display": "Uttar Pradesh",
      "value": "Uttar Pradesh",
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
                      child: CircularPercentIndicator(
                        radius: 170.0,
                        lineWidth: 12.0,
                        animation: true,
                        backgroundColor: Colors.white,
                        percent: 0,
                        center: Text(
                          "Registration Progress",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressColor: Colors.green,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Text("Register Here", style: TextStyle(color: Colors.white, fontSize: 32),),
                    ),
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
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[

                          SizedBox(height: 30,),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: <Widget>[


                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: _buildForm(),
                                ),

                                InkWell(
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      print(_phoneNumberController.text);
                                      print(_brandController.text);
                                      print(_fullBrandNameController.text);
                                      print(currentStateSelected);
                                      print(_vendorNameController.text);
                                      print(_cityController.text);
                                      print(_countryController.text);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StockDetailsPage(
                                                _phoneNumberController.text,
                                                _brandController.text,
                                                _fullBrandNameController.text,
                                                currentStateSelected,
                                              _vendorNameController.text,
                                              _cityController.text,
                                              _countryController.text
                                            )),
                                      );
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
                                          color: Color(0xff8f9db5).withOpacity(0.8),
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
                          ),
                          SizedBox(height: 40,),


                          SizedBox(height: 10,),


                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                          SizedBox(height: 40,),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
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
              controller: _vendorNameController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Name cannot be empty';
                } else if (value.length < 3) {
                  return 'Name must be at least 3 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
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
            child: TextFormField(
              controller: _cityController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'City cannot be empty';
                } else if (value.length < 3) {
                  return 'City must be at least 3 characters long.';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropDownFormField(
              validator: (dynamic value) {
                if (value == null) {
                  return 'State cannot be empty';
                }
                return null;
              },
              titleText: 'State',
              value: currentStateSelected,
              onSaved: (value) {
                setState(() {
                  currentStateSelected = value;
                });
              },
              onChanged: (value) {
                setState(() {
                  currentStateSelected = value;
                });
              },
              dataSource: _statesOfIndia,
              textField: 'display',
              valueField: 'value',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _countryController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Country cannot be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


