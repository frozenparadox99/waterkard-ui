import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/driver_module/card/driver_customerpage.dart';
import 'package:waterkard/ui/pages/driver_module/daily_inventory/dailyinventory_load.dart';
import 'package:waterkard/ui/pages/driver_module/edit_profile.dart';
import 'package:waterkard/ui/pages/driver_module/my_customer.dart';
import 'package:waterkard/ui/pages/driver_module/order/orders_dashboard.dart';

class SidebarDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Johanne Dae'),
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
          ListTile(
            leading: Icon(
              Icons.assessment_outlined,
            ),
            title: Text('Daily Inventory'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DriverDailyInventoryLoadPage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.group,
            ),
            title: Text('My Customers'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DriverCustomerMainPage()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_business_outlined,
            ),
            title: Text('Orders'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderDashboard()));
            },
          ),

          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.pause_circle_outline_outlined,
            ),
            title: Text('How To Use'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.forum_outlined,
            ),
            title: Text('Feedback'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.g_translate_outlined,
            ),
            title: Text('Change Language'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.vpn_key_outlined,
            ),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
            ),
            title: Text('Sign Out'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}