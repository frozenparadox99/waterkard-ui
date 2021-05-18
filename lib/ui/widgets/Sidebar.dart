import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/add_driver_pages/all_drivers.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_load.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/total_inventory_add.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('some-name'),
            accountEmail: Text('example@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/profile_user.jpg',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/profile-bg3.jpg')),
            ),
          ),
          ExpansionTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Inventory'),
            children: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DailyInventoryLoadPage()));
                },
                child: Text('Daily Inventory'),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TotalInventoryAddPage()));
                },
                child: Text('Total Inventory'),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.card_membership_outlined),
            title: Text('Cards'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Customer Group'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.car_rental),
            title: Text('Drivers'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllDrivers()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Orders'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('My Products'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Payments'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Invoice'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.description),
            title: Text('Statements'),
            onTap: () => null,
          ),
          Divider(),
          ListTile(
            title: Text('How to use'),
            leading: Icon(Icons.info_outline),
            onTap: () => null,
          ),
        ],
      ),
    );
  }
}
