import 'package:flutter/material.dart';

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
                  image: AssetImage(
                      'assets/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Inventory'),
            onTap: () => null,
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
            onTap: () => null,
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