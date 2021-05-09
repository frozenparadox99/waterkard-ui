import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';

class ChooseUserTypePage extends StatefulWidget {
  const ChooseUserTypePage({Key key}) : super(key: key);

  @override
  _ChooseUserTypePageState createState() => _ChooseUserTypePageState();
}

class _ChooseUserTypePageState extends State<ChooseUserTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: Column(

        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: CustomPaint(
                  painter: pathPainter(),
                ),
              ),
              Container(
                padding: EdgeInsets.all(50),
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/waterkard.png',
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Yes I Am!", style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),),
                      ],
                    ),
                    Row(
                      children: [SizedBox(height: 60,)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                            child: Text(
                              "Vendor",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [SizedBox(height: 30,)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                            onPressed: () {
                              print("RaisedButton");
                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                            child: Text(
                              "Driver",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [SizedBox(height: 30,)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                            onPressed: () {
                              print("RaisedButton");
                            },
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))),
                            child: Text(
                              "New User",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),


            ],
          )
        ],
      ),
    );
  }
}


class pathPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xffE4E2FF);
    paint.style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, size.height*0.4);
    path.quadraticBezierTo(size.width*0.35, size.height*0.40, size.width*0.58, size.height*0.6);
    path.quadraticBezierTo(size.width*0.72, size.height*0.8, size.width*0.92, size.height*0.8);
    path.quadraticBezierTo(size.width*0.98, size.height*0.8, size.width, size.height*0.82);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}