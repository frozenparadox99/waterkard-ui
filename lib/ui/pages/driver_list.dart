import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/api/constants.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:waterkard/ui/pages/add_driver_pages/add_driver.dart';
import 'package:waterkard/ui/pages/add_driver_pages/edit_driver.dart';
import 'package:waterkard/ui/pages/vendor_login_page.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'missing_jars_pages/tracking_jars.dart';


final Color activeColor = Color(0xffFF2E63);
final Color inactiveColor = Color(0xff6C73AE);

class ListAllDrivers extends StatefulWidget {
  @override
  _ListAllDriversState createState() => _ListAllDriversState();
}

class _ListAllDriversState extends State<ListAllDrivers> {
  String selection;
  String uid;
  List<Transaction> allDriversForVendor = [];

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
    getAllDrivers();
  }

  void getAllDrivers () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("vendorId");
    print(id);

    if(id!=null){
      String apiURL =
          "$API_BASE_URL/api/v1/vendor/driver/all?vendor=$id";
      var response = await http.get(Uri.parse(apiURL));
      var body = response.body;

      var decodedJson = jsonDecode(body);

      print(body);
      print(decodedJson);
      if(decodedJson["success"]!=null && decodedJson["success"] == true && decodedJson["data"]!=null && decodedJson["data"]["drivers"]!=null){
        List<dynamic> receivedProducts = decodedJson["data"]["drivers"];
        List<dynamic> formatted = receivedProducts.map((e) => {
          "image": "assets/profile_user.jpg",
          "name":e["name"],
          "isEdit": true,
          "groupName": e["group"]["name"],
          "phoneNumber": e["mobileNumber"],
          "passWord":e["password"],
          "id":e["_id"]
        }).toList();



        setState(() {
          allDriversForVendor = formatted.map((item) => Transaction(
              image:item['image'],
              name:item['name'],
              groupName:item['groupName'],
              isEdit:item['isEdit'],
              phoneNumber:item['phoneNumber'],
              passWord:item['passWord'],
              driverId:item['id']
          )).toList();
        });

      }

    }
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
            onPressed: ()  {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => AddDriver()));
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.filter_alt),
          //   onPressed: ()  {},
          // ),
          // IconButton(
          //   icon: Icon(Icons.search),
          //   onPressed: ()  {},
          // ),
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
      // backgroundColor: Color(0xff010A43),
      backgroundColor: Color(0xFF4267B2),
      body: Stack(
        children: [

          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "All Drivers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.2,
                //   child: Swiper(
                //     itemBuilder: (ctx, idx) => Card(
                //       index: idx,
                //     ),
                //     curve: Curves.ease,
                //     pagination: new SwiperPagination(
                //       builder: SwiperPagination.rect,
                //     ),
                //     itemCount: cardList.length,
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      // color: Color(0xff0E164C),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 5,
                          width: 100,
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "List",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       "Sort By",
                            //       style: TextStyle(
                            //         color: inactiveColor,
                            //         fontSize: 18,
                            //       ),
                            //     ),
                            //     SizedBox(width: 10),
                            //     DropdownButton(
                            //       value: selection,
                            //       hint: Text(
                            //         "Choose",
                            //         style: TextStyle(
                            //           color: activeColor.withOpacity(0.5),
                            //           fontSize: 17,
                            //         ),
                            //       ),
                            //       dropdownColor: Color(0xff010A43),
                            //       iconEnabledColor: activeColor,
                            //       style: TextStyle(
                            //         color: activeColor,
                            //         fontSize: 17,
                            //       ),
                            //       items: listItems.map((e) {
                            //         return DropdownMenuItem(
                            //           value: e,
                            //           child: Text(e),
                            //         );
                            //       }).toList(),
                            //       onChanged: (value) {
                            //         setState(() {
                            //           selection = value;
                            //         });
                            //       },
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => TransactionTile(
                              groupName: allDriversForVendor[i].groupName,
                              imageUrl: allDriversForVendor[i].image,
                              name: allDriversForVendor[i].name,
                              isEdit: allDriversForVendor[i].isEdit,
                              phoneNumber: allDriversForVendor[i].phoneNumber,
                              passWord: allDriversForVendor[i].passWord,
                              driverId:allDriversForVendor[i].driverId,
                            ),
                            itemCount: allDriversForVendor.length,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



List<String> listItems = ["Recent", "Ascending", "Descending"];

class Transaction {
  String image;
  String name;
  String groupName;
  bool isEdit;
  String phoneNumber;
  String passWord;
  String driverId;

  Transaction({this.image, this.name, this.groupName, this.isEdit,this.phoneNumber,this.passWord,this.driverId});
}

List<Transaction> transactions = [
  Transaction(
      image: "assets/profile_user.jpg",
      name: "Ayush gupta",
      groupName: "Group A",
      isEdit: true,
      phoneNumber: "9812346372",
      passWord: "abcd"
  ),
  Transaction(
      image: "assets/profile_user.jpg",
      groupName: "Group B",
      name: "Alena Lopez",
      isEdit: true,
      phoneNumber: "9812346372",
      passWord: "abcd"
  ),
  Transaction(
      image: "assets/profile_user.jpg",
      groupName: "Group C",
      name: "Sheldon Cooper",
      isEdit: true,
      phoneNumber: "9812346372",
      passWord: "abcd"
  ),
  Transaction(
      image: "assets/profile_user.jpg",
      groupName: "Group D",
      name: "Virat",
      isEdit: true,
      phoneNumber: "9812346372",
      passWord: "abcd"
  ),
  Transaction(
      image: "assets/profile_user.jpg",
      groupName: "Group E",
      name: "Bennedict Holmes",
      isEdit: true,
      phoneNumber: "9812346372",
      passWord: "abcd"
  ),
];

class TransactionTile extends StatelessWidget {
  final String imageUrl, name, groupName, passWord, phoneNumber, driverId;
  final bool isEdit;

  TransactionTile({this.groupName, this.imageUrl, this.name, this.isEdit, this.passWord, this.phoneNumber, this.driverId});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TrackingJars(this.driverId,this.name,this.groupName)));
      },
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(imageUrl),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                color: inactiveColor,
                fontSize: 18,
              ),
            ),
            Text(
              groupName,
              style: TextStyle(
                color: inactiveColor,
                fontSize: 15,
              ),
            ),
          ],
        ),


      ),
    );
  }
}

