import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/add_driver_pages/all_drivers.dart';
import 'package:waterkard/ui/pages/add_new_group_pages/list_groups.dart';
import 'package:waterkard/ui/pages/cards_customer/cards.dart';
import 'package:waterkard/ui/pages/customer_payment_pages/customer_payment_list.dart';
import 'package:waterkard/ui/pages/deposite_pages/deposite_list.dart';
import 'package:waterkard/ui/pages/dispenser_pages/dispenser_list.dart';
import 'package:waterkard/ui/pages/driver_payment_pages/driver_payment_list.dart';
import 'package:waterkard/ui/pages/inventory_pages/daily_inventory/daily_inventory_load.dart';
import 'package:waterkard/ui/pages/inventory_pages/total_inventory/total_inventory_add.dart';
import 'package:waterkard/ui/pages/invoice_pages/select_invoice.dart';
import 'package:waterkard/ui/pages/my_products_pages/all_products.dart';
import 'package:waterkard/ui/pages/order/orders_dashboard.dart';
import 'package:waterkard/ui/pages/vendor_home_page.dart';

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
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerCardPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Customer Group'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListGroups()));
            },
          ),
          ListTile(
            leading: Icon(Icons.car_rental),
            title: Text('Drivers'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllDrivers()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Orders'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OrderDashboard()));
            },
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('My Products'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllProducts()));
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.payment),
            title: Text('Payments'),
            children: [
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerPaymentList()));
                },
                child: Text('Customer Payment'),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverPaymentList()));
                },
                child: Text('Driver Payment     '),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.store),
            title: Text('My Shop'),

            children: [
              // ignore: deprecated_member_use

              ListTile(

                title: Text('Deposits'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DepositeList()));
                },
              ),
              // ignore: deprecated_member_use
              ListTile(

                title: Text('Dispensers'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DispenserList()));
                },
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Invoice'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectInvoice()));
            },
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
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VendorHomePage()));
            },
          ),
        ],
      ),
    );
  }
}
