import 'package:flutter/material.dart';
import 'package:waterkard/services/whatsapp_service.dart';
import 'package:waterkard/ui/pages/add_driver_pages/all_drivers.dart';
import 'package:waterkard/ui/widgets/shared_button.dart';


final Color activeColor = Color(0xffFF2E63);
final Color inactiveColor = Color(0xff6C73AE);

class NewTransactionTile extends StatelessWidget {
  final String imageUrl, name, groupName, passWord, phoneNumber;
  final bool isEdit;

  NewTransactionTile({this.groupName, this.imageUrl, this.name, this.isEdit, this.passWord, this.phoneNumber});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imageUrl),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
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
                // Status(
                //   status: isEdit,
                // ),
                // Status(
                //   status: !isEdit,
                // ),
              ],
            ),
          ),
          SizedBox(width: 10,),
          Column(
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
              SizedBox(height: 5,),
              ShareButton(
                  onPressed: () {
                    WhatsAppService().toContact(
                      contactNumber: phoneNumber,
                      message: "Your password is: $passWord",
                    );
                  }
              )
            ],
          ),
        ],
      ),
    );
  }
}