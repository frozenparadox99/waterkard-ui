import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/driver_module/order/order_added_successfully.dart';

final Color activeColor = Color(0xffFF2E63);
final Color inactiveColor = Color(0xff6C73AE);

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  String selection;
  List<String> listItems = ["Recent", "Ascending", "Descending"];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1.0,
      backgroundColor: Colors.white,
      child: Container(
        width: 500,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Add Order',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Customer',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
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
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Product',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
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
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Prefered Date',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
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
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Prefered Time',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
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
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jar Qty.',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 20,
                ),
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
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Share on Whatsapp'),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            new MaterialPageRoute(builder: (context) {
                          return OrderAddedSuccessfullyPage();
                        }));
                      },
                      child: Text('Submit'),
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}