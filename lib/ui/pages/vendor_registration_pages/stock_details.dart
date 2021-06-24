import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:waterkard/ui/pages/vendor_details_pages/vendor_get_details.dart';
import 'package:waterkard/ui/pages/vendor_registration_pages/general_details.dart';
import 'package:waterkard/ui/pages/vendor_registration_pages/group_and_driver_details.dart';

class StockDetailsPage extends StatefulWidget {
  final String phoneNumber;
  final String brand;
  final String fullBrandName;
  final String stateOfIndia;
  final String name;
  final String city;
  final String country;
  StockDetailsPage(this.phoneNumber,this.brand,this.fullBrandName,this.stateOfIndia, this.name, this.city, this.country );

  @override
  _StockDetailsPageState createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _coolJarStockController = TextEditingController();
  final _bottleJarStockController = TextEditingController();

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
                        percent: 0.33,
                        center: Text(
                          "Registration Progress",
                          style: TextStyle(color: Colors.white),
                        ),
                        progressColor: Color(0xFF1EAE98),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Text("Stock Details", style: TextStyle(color: Colors.white, fontSize: 32),),
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
                                      print(_coolJarStockController.text);
                                      print(_bottleJarStockController.text);
                                      print(widget.stateOfIndia);
                                      print(widget.fullBrandName);
                                      print(widget.brand);
                                      print(widget.phoneNumber);
                                      print(widget.name);
                                      print(widget.country);
                                      print(widget.city);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => GroupAndDriverDetailsPage(
                                                widget.phoneNumber,
                                                widget.brand,
                                                widget.fullBrandName,
                                                widget.stateOfIndia,
                                                widget.name,
                                                widget.city,
                                                widget.country,
                                                _coolJarStockController.text,
                                                _bottleJarStockController.text
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
                                        'Continue',
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
                                InkWell(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GeneralDetailsPage()));
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Want to change something? ',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff8f9db5).withOpacity(0.8),
                                          ),
                                        ),

                                        TextSpan(
                                          text: 'Go Back',
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
              keyboardType: TextInputType.number,
              controller: _coolJarStockController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Cool Jar stock can not be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Cool Jar Stock',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _bottleJarStockController,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Bottle Jar stock can not be empty';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Bottle Jar Stock',
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


