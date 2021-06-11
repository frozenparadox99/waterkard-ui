import 'package:flutter/material.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';

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

class DriverCustomerMainPage extends StatefulWidget {
  @override
  _DriverCustomerMainPageState createState() => _DriverCustomerMainPageState();
}

class _DriverCustomerMainPageState extends State<DriverCustomerMainPage> {
  void reorderCard(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final item = items.removeAt(oldindex);
      items.insert(newindex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarDriver(),
      appBar: AppBar(
        title: Text('Cards'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.filter_alt,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: ReorderableListView(
          cacheExtent: 4,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          onReorder: reorderCard,
          children: [
            for (final item in items)
              Card(
                key: ValueKey(item),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 10,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: ListTile(
                          leading: Icon(Icons.add_ic_call_outlined,
                              color: Color(0xFF5F6AF8)),
                          title: Text(item['name'].toString(),
                              style: TextStyle(color: Colors.blue)),
                          subtitle: Text(item['group'].toString(),
                              style: TextStyle(color: Colors.blue)),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(Icons.send_sharp),
                                Icon(Icons.add_circle_outline_sharp),
                                Icon(Icons.brightness_1_outlined),
                              ])),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                      child: Divider(
                        thickness: 0.8,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Sold:'),
                              Text(item['sold'].toString()),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Balance:'),
                              Text(item['balance'].toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Empty:'),
                              Text(item['empty'].toString()),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Balance Payment:'),
                              Text(item['balance-payment'].toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}