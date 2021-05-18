import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';

import '../vendor_login_page.dart';

final Color activeColor = Color(0xffFF2E63);
final Color inactiveColor = Color(0xff6C73AE);

class AllDrivers extends StatefulWidget {
  @override
  _AllDriversState createState() => _AllDriversState();
}

class _AllDriversState extends State<AllDrivers> {
  String selection;
  String uid;

  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid;
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
      // backgroundColor: Color(0xff010A43),
      backgroundColor: Color(0xFF5F6AF8),
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
                            Row(
                              children: [
                                Text(
                                  "Sort By",
                                  style: TextStyle(
                                    color: inactiveColor,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 10),
                                DropdownButton(
                                  value: selection,
                                  hint: Text(
                                    "Choose",
                                    style: TextStyle(
                                      color: activeColor.withOpacity(0.5),
                                      fontSize: 17,
                                    ),
                                  ),
                                  dropdownColor: Color(0xff010A43),
                                  iconEnabledColor: activeColor,
                                  style: TextStyle(
                                    color: activeColor,
                                    fontSize: 17,
                                  ),
                                  items: listItems.map((e) {
                                    return DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selection = value;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (ctx, i) => TransactionTile(
                              groupName: transactions[i].groupName,
                              imageUrl: transactions[i].image,
                              name: transactions[i].name,
                              isEdit: transactions[i].isEdit,
                              phoneNumber: transactions[i].phoneNumber,
                              passWord: transactions[i].passWord,
                            ),
                            itemCount: transactions.length,
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

  Transaction({this.image, this.name, this.groupName, this.isEdit,this.phoneNumber,this.passWord});
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
  final String imageUrl, name, groupName, passWord, phoneNumber;
  final bool isEdit;

  TransactionTile({this.groupName, this.imageUrl, this.name, this.isEdit, this.passWord, this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      subtitle: Column(
        children: [

          Status(
            status: isEdit,
          ),
          Status(
            status: !isEdit,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$phoneNumber",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          Text(
            "Pass: $passWord",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xffFF2E63),
            ),
          ),
        ],
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
      margin: EdgeInsets.only(
        top: 5,
        right: 75,
      ),
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: status ? Colors.teal : Colors.red,
      ),
      child: InkWell(
        onTap: (){
          print("Here");
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