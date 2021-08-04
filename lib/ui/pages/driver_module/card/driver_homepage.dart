import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/services/api_services.dart';
import 'package:waterkard/services/misc_services.dart';
import 'package:waterkard/services/shared_prefs.dart';
import 'package:waterkard/ui/pages/add_new_customer_pages/customer_card.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_jar_and_payments.dart';
import 'package:waterkard/ui/pages/missing_jars_pages/tracking_jars.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:reorderables/reorderables.dart';

import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';

import 'driver_addcustomerpage.dart';
import 'driver_filter.dart';

var items = [
  {
    "name": "Mr.Shivraj Patel",
    "group": "Group-Hadapur",
    "sold": "02",
    "empty": "02",
    "balance": "02",
    "balance-payment": "02",
  },
  {
    "name": "Mr.Santosh Kumar",
    "group": "Group-Madavpur",
    "sold": "02",
    "empty": "02",
    "balance": "02",
    "balance-payment": "02",
  },
  {
    "name": "Mr.Shivraj Patel",
    "group": "Group-Hadapur",
    "sold": "02",
    "empty": "02",
    "balance": "02",
    "balancepayment": "02",
  },
  {
    "name": "Mr.Santosh Kumar",
    "group": "Group-Madavpur",
    "sold": "02",
    "empty": "02",
    "balance": "02",
    "balance-payment": "02",
  },
  {
    "name": "Mr.Santosh Kumar",
    "group": "Group-Madavpur",
    "sold": "02",
    "empty": "02",
    "balance": "02",
    "balance-payment": "02",
  },
];

const TopCardList = [

  {
    "color":Colors.pinkAccent,
    "title":"Missing Jars",
    "desc": "Missing Jars: 5",
    "page":"3",
    "misc":"Date: 27/05/2021",

  },

];

final DriverList = [
  {
    "color":Colors.pink[100],
    "title":"Number: 9711345582",
    "image":"https://unsplash.com/photos/c_GmwfHBDzk/download?force=true&w=640",
    "jars":"Loaded Jars: 4",
    "name":"Driver 1",
  },
  {
    "color":Colors.indigo[100],
    "title":"Number: 9711345582",
    "image":"https://unsplash.com/photos/_jOsfORtjew/download?force=true&w=640",
    "jars":"Loaded Jars: 10",
    "name":"Driver 2",
  },
  {
    "color":Colors.cyan[100],
    "title":"Number: 9711345582",
    "image":"https://unsplash.com/photos/c_GmwfHBDzk/download?force=true&w=640",
    "jars":"Loaded Jars: 12",
    "name":"Driver 3",

  },
  {
    "color":Colors.red[100],
    "title":"Number: 9711345582",
    "image":"https://unsplash.com/photos/_jOsfORtjew/download?force=true&w=640",
    "jars":"Loaded Jars: 14",
    "name":"Driver 4",

  }
];

const nameTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 32
);
const cardNameTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 22
);
const subTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w400,
    fontSize: 16
);
const titleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w300,
    fontSize: 30
);
final subTitleTextStyle = TextStyle(
    color: Colors.grey[800],
    fontWeight: FontWeight.w800,
    fontSize: 20
);
final ratingTextStyle = TextStyle(
    color: Colors.grey[800],
    fontWeight: FontWeight.w500,
    fontSize: 20
);
const detailsTitleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 32
);
const detailsSubTitleTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w500,
    fontSize: 22
);
const courseStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w600,
    fontSize: 20
);

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  String uid;
  List<Widget> _rows;
  List<Widget> _rows2;
  Map customersMap;
  bool isLoading = true;
  String driverName = "Sample";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomers();
    // uid = FirebaseAuth.instance.currentUser.uid;

    // _rows = items.map((item) {
    //   return Card(
    //     key: ValueKey(item),
    //     shadowColor: Colors.black,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20.0),
    //     ),
    //     elevation: 10,
    //     color: Colors.white,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //         Container(
    //           color: Colors.white,
    //           child: ListTile(
    //               leading: Icon(Icons.add_ic_call_outlined,
    //                   color: Color(0xFF5F6AF8)),
    //               title: Text(item['name'].toString(),
    //                   style: TextStyle(
    //                       color: Colors.blue.withOpacity(0.6))),
    //               subtitle: Text(item['group'].toString(),
    //                   style: TextStyle(
    //                       color: Colors.blue.withOpacity(0.6))),
    //               trailing: Row(
    //                   mainAxisSize: MainAxisSize.min,
    //                   children: <Widget>[
    //                     Icon(Icons.send_sharp),
    //                     Icon(Icons.add_circle_outline_sharp),
    //                     Icon(Icons.brightness_1_outlined),
    //                   ])),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
    //           child: Divider(
    //             thickness: 0.8,
    //             color: Colors.black,
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
    //           child: Row(
    //             mainAxisAlignment:
    //             MainAxisAlignment.spaceBetween,
    //             children: [
    //               Row(
    //                 children: [
    //                   Text('Sold:'),
    //                   Text(item['sold'].toString()),
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   Text('Balance:'),
    //                   Text(item['balance'].toString()),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(15, 2, 15, 5),
    //           child: Row(
    //             mainAxisAlignment:
    //             MainAxisAlignment.spaceBetween,
    //             children: [
    //               Row(
    //                 children: [
    //                   Text('Empty:'),
    //                   Text(item['empty'].toString()),
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   Text('Balance Payment:'),
    //                   Text(item['balance-payment'].toString()),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }).toList();
    //
    //
    //
    // _rows2 = items.map((item) {
    //   return Container(
    //     margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
    //     decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(32),
    //         boxShadow: [
    //           BoxShadow(
    //               color: Colors.black.withOpacity(0.2),
    //               spreadRadius: 1,
    //               blurRadius: 8
    //           )
    //         ]),
    //     child: Container(
    //       margin: EdgeInsets.only(left: 24),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             height: 39,
    //             width:150,
    //             margin: EdgeInsets.only(top: 16, bottom: 16),
    //             decoration: BoxDecoration(
    //               color: Colors.white,
    //               borderRadius: BorderRadius.circular(24),
    //             ),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //
    //                 SizedBox(
    //                   width: 2,
    //                 ),
    //                 Text(
    //                   item["group"],
    //                   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Row(
    //               mainAxisSize: MainAxisSize.max,
    //               children: <Widget>[
    //                 Text(item["name"],
    //                   style: cardNameTextStyle,),
    //                 Spacer(),
    //                 Icon(Icons.send_sharp,color: Colors.white,),
    //                 SizedBox(width: 4,),
    //                 IconButton(
    //                   icon: Icon(Icons.add_circle_outline_sharp,color: Colors.white,),
    //                   onPressed: (){},
    //                 )
    //
    //               ]),
    //
    //           Container(
    //             margin: EdgeInsets.only(top: 16),
    //             child: Row(
    //               children: [
    //                 // Hero(
    //                 //   tag:image,
    //                 //   child: Container(
    //                 //     height: 72,
    //                 //     width: 72,
    //                 //     decoration: BoxDecoration(
    //                 //         image: DecorationImage(
    //                 //             image: NetworkImage(image),
    //                 //             fit: BoxFit.cover
    //                 //         ),
    //                 //         borderRadius: BorderRadius.circular(36),
    //                 //         border: Border.all(width: 3.0,color: Colors.white)
    //                 //     ),
    //                 //   ),
    //                 // ),
    //                 Container(
    //                   // margin: EdgeInsets.only(left: 16),
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Text("Sold: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                           SizedBox(width: 150,),
    //                           Text("Empty: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                         ],
    //                       ),
    //                       SizedBox(height: 8,),
    //                       Row(
    //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Text("Balance: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                           SizedBox(width: 50,),
    //                           Text("Balance-Payment: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                         ],
    //                       ),
    //                       SizedBox(height: 8,),
    //                       // Text("Sold: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                       // SizedBox(height: 8,),
    //                       // Text("Empty: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                       // SizedBox(height: 8,),
    //                       // Text("Balance: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                       // SizedBox(height: 8,),
    //                       // Text("Balance-Payment: ${item['sold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
    //                       // SizedBox(height: 8,),
    //                       // Text("Empty: 03", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),)
    //                     ],
    //                   ),
    //                 )
    //               ],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   );
    // }).toList();
  }

  getCustomers() async{
    isLoading = true;

    Map map  = await ApiServices().getDriversCustomers();
    customersMap = map["data"];
    if(customersMap==null){
      setState(() {
        isLoading = false;
      });
      return;
    }

    List list = customersMap["customers"];
    _rows2 = list.map((item) {
      return customerCard(item);
    }).toList();

    setState(() {
      driverName = SharedPrefsService.getDriverName();
      isLoading = false;
    });
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      Widget row = _rows.removeAt(oldIndex);
      _rows.insert(newIndex, row);
    });
  }

  void _onReorder2(int oldIndex, int newIndex) {
    setState(() {
      Widget row = _rows2.removeAt(oldIndex);
      _rows2.insert(newIndex, row);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarDriver(),
      appBar: AppBar(
        title: Text('Home'),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.add_circle_outline,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => DriverAddCustomerCardPage()));
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(
        //       Icons.filter_alt,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => DriverCardsFilterPage()));
        //     },
        //   ),
        //   IconButton(
        //     icon: Icon(
        //       Icons.search,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {},
        //   )
        // ],
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          color: Color(0xFF4267B2),
          child: Column(
            children: [
              Container(
                height: 128,
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                    ),
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("https://unsplash.com/photos/Y7C7F26fzZM/download?force=true&w=640"),
                              fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(width: 2.0,color: Colors.white)
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $driverName",
                          style: nameTextStyle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Welcome to Waterkard",
                          style: subTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(48),
                        topRight: Radius.circular(48),
                      )),
                  child: body(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget body(){

    if(isLoading){
      return Center(child: CircularProgressIndicator());
    }

    if(customersMap==null || customersMap.isEmpty){
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Oops! Network Error Occurred",
              style: TextStyle(
                  fontSize: 18
              ),
            ),
            InkWell(
              onTap: (){
                getCustomers();
                setState(() {

                });
              },
              child: Text("Retry?",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue
                ),
              ),
            ),
          ],
        ),
      );
    }

    if(customersMap["customers"]==null || customersMap["customers"].isEmpty){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("No Customers Available"),
        ],
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 32, left: 32),
            child: Text(
              "Customers",
              style: titleTextStyle,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 16),
          sliver: ReorderableSliverList(
            delegate: ReorderableSliverChildListDelegate(_rows2),
            onReorder: _onReorder2,
          ),
        ),
      ],
    );
  }

  Widget customerCard(Map item){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8
            )
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                  width: 2,
                ),
                Text(
                  item["group"],
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  item["name"],
                  style: cardNameTextStyle,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.send_sharp,color: Colors.white,),
                  onPressed: (){
                    Map address = item["address"];
                    List coordinates = address["coordinates"];
                    // launchMap(
                    //   lat: coordinates.first.toString(),
                    //   lng: coordinates.last.toString(),
                    // );
                    navigateTo(coordinates.first, coordinates.last);
                  },
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverJarAndPaymentPage(item["_id"], SharedPrefsService.getDriverId(), item["mobileNumber"].split("+91")[1])));
                  },
                  child: Icon(Icons.add_circle_outline_sharp,color: Colors.white,),
                ),

              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Sold: ${item['totalSold']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),

              Text("Empty: ${item['totalEmptyCollected']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Balance: ${item['totalBalance']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),

              Text("Deposit: ${item['totalDeposit']}", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
            ],
          ),
        ],
      ),
    );
  }

}

class SingleCard extends StatelessWidget {
  final Color color;
  final String title;
  final String desc;
  final String misc;
  final String page;

  const SingleCard({Key key, this.color, this.title, this.desc, this.misc, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8
            )
          ]),
      child: Container(
        margin: EdgeInsets.only(left: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 39,
              width: 50,
              margin: EdgeInsets.only(top: 16, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    "Info",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text("Total Stock: 200",
              style: cardNameTextStyle,),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  // Hero(
                  //   tag:image,
                  //   child: Container(
                  //     height: 72,
                  //     width: 72,
                  //     decoration: BoxDecoration(
                  //         image: DecorationImage(
                  //             image: NetworkImage(image),
                  //             fit: BoxFit.cover
                  //         ),
                  //         borderRadius: BorderRadius.circular(36),
                  //         border: Border.all(width: 3.0,color: Colors.white)
                  //     ),
                  //   ),
                  // ),
                  Container(
                    // margin: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Loaded-Jars: 30", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
                            SizedBox(width: 40,),
                            Text("Cust. Balance: 12", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Sold: 2", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
                            SizedBox(width: 140,),
                            Text("Empty: 2", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Godown-Stock: 2", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
                            SizedBox(width: 40,),
                            Text("Missing-Jars: 2", style: TextStyle(color: Colors.white.withOpacity(0.8),fontSize: 16),),
                          ],
                        ),

                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class DriverCard extends StatelessWidget {
  final Color color;
  final String title;
  final String image;
  final String name;
  final String jars;
  const DriverCard({Key key, @required this.color, this.title, this.image, this.name, this.jars}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2),spreadRadius: 1,blurRadius: 8)
          ]
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(width: 3.0,color: Colors.white)
                  ),
                ),
                SizedBox(width: 8,),
                Flexible(child: Text(name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),))
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.deepOrange,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        jars,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),

                  Text(
                    title,
                    style: subTitleTextStyle,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// SliverToBoxAdapter(
//   child: Padding(
//     padding: EdgeInsets.only(top: 32, left: 32),
//     child: Text(
//       "Current Stock",
//       style: titleTextStyle,
//     ),
//   ),
// ),
// SliverToBoxAdapter(
//   child: Container(
//     width: MediaQuery.of(context).size.width,
//     height: 232,
//     margin: EdgeInsets.only(top: 16),
//     child: PageView(
//       controller: PageController(viewportFraction: 0.8,initialPage: 2),
//       children:TopCardList.map((e) {
//         return GestureDetector(
//           onTap: (){
//             // Navigator.pushReplacement(
//             //     context, MaterialPageRoute(builder: (context) => TrackingJars()));
//           },
//
//           child: SingleCard(
//             color: e["color"],
//             misc: e["misc"],
//             page: e["page"],
//             title: e["title"],
//             desc: e["desc"],
//           ),
//         );
//       }).toList(),
//     ),
//   ),
// ),

// SliverToBoxAdapter(
//   child: Padding(
//     padding: EdgeInsets.only(top: 32, left: 32),
//     child: Text(
//       "Customers",
//       style: titleTextStyle,
//     ),
//   ),
// ),
// ReorderableSliverList(
//   delegate: ReorderableSliverChildListDelegate(_rows),
//
//   onReorder: _onReorder,
// ),

// SliverPadding(
//   padding:
//   EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//   sliver: SliverGrid.count(
//     mainAxisSpacing: 24,
//     crossAxisSpacing: 16,
//     childAspectRatio: .95,
//     crossAxisCount: 2,
//     children: DriverList.map((e) {
//       return DriverCard(
//         color: e["color"],
//         name: e["name"],
//         jars: e["jars"],
//         title: e["title"],
//         image: e["image"],
//       );
//     }).toList(),
//   ),
// )