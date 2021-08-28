import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/deposite_pages/deposite_update.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
class DepositeList extends StatefulWidget {
  @override
  _DepositeListState createState() => _DepositeListState();
}

class _DepositeListState extends State<DepositeList> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF5F6AF8),

      drawer: Sidebar(),
      appBar: AppBar(
        title: Text('Deposits'),
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
              // await FirebaseAuth.instance.signOut();
              // Navigator.pushReplacement(
              //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 30, right: 30),
        decoration: BoxDecoration(
            color: Color(0xfff4f6fd),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60),
              topRight: Radius.circular(60),
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: <Widget>[
            //     Text("Hello Developers", style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.blueAccent
            //     ),),
            //     Container(
            //       height: 40,
            //       width: 40,
            //
            //     )
            //   ],
            // ),
            Center(
              child: Text("All Deposits", style: TextStyle(color: Colors.black, fontSize: 40),),
            ),
            SizedBox(height: 25,),
            Center(
              child: Text('Total Deposit Amount: 1500', style: TextStyle(
                  fontSize: 20,
                  height: 1.3,
                  fontWeight: FontWeight.w700
              ),),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            courseWidget('Rs.500', 'Customer 1 ', 'img1', Color(0xffff6a65), Color(0xffff5954)),
                            SizedBox(height: 20,),
                            courseWidget('Rs.600', 'Customer 3', 'img2', Color(0xffe9eefa), Colors.white),
                            SizedBox(height: 20,),
                            courseWidget('Rs.600', 'Customer 5', 'img1', Color(0xffff6a65), Color(0xffff5954)),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // SizedBox(height: 50,),
                            courseWidget('Rs.600', 'Customer 2', 'img3', Color(0xffe9eefa), Colors.white),
                            SizedBox(height: 20,),
                            courseWidget('Rs.600', 'Customer 4', 'img4', Color(0xffbdcddfa), Color(0xffcedaff)),
                            SizedBox(height: 20,),
                            courseWidget('Rs.600', 'Customer 6', 'img3', Color(0xffe9eefa), Colors.white),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
  Container courseWidget(String category, String title, String img, Color categoryColor, Color bgColor)
  {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: InkWell(
        onTap: (){},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),

              ),
              child: Text('$category', style: TextStyle(
                  color: (categoryColor == Color(0xffe9eefa) ? Color(0xff2657ce) : Colors.white)
              ),),
            ),
            SizedBox(height: 10,),
            Text('$title', style: TextStyle(
              color: (bgColor == Color(0xffff5954)) ? Colors.white : Colors.black,
              fontSize: 20,
              height: 1,
            ),),
            SizedBox(height: 10,),
            // Row(
            //   children: <Widget>[
            //     Container(
            //       height: 5,
            //       width: 100,
            //       color: (bgColor == Color(0xffff5954)) ? Colors.red : Color(0xff2657ce),
            //     ),
            //     Expanded(
            //       child: Container(
            //         height: 5,
            //         color: (bgColor == Color(0xffff5954)) ? Colors.white.withOpacity(0.5) : Color(0xff2657ce).withOpacity(0.5),
            //       ),
            //     )
            //   ],
            // ),
            // SizedBox(height: 20,),
            // Status(status: true,),
            // SizedBox(height: 20,),
            // Status(status: false,),
            // SizedBox(height: 40,),

          ],
        ),
      ),
    );
  }


}

class Status extends StatelessWidget {
  bool status;
  Status({this.status});
  @override
  Widget build(BuildContext context) {
    return Container(

      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: status ? Colors.teal : Colors.red,
      ),
      child: InkWell(
        onTap: (){
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DepositUpdate()));
        },
        child: Row(
          children: [
            SizedBox(width: 3),
            status ?
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ): Icon(
              Icons.cancel,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              status ? "Edit" : "Delete",
              style: TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}