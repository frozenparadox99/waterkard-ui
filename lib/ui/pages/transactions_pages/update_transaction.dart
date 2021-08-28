import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/data/models/transaction_model.dart';
import 'package:waterkard/services/api_services.dart';
import 'package:waterkard/ui/widgets/dialogue_box.dart';
import 'package:waterkard/ui/widgets/shared_button.dart';
import 'package:waterkard/utils.dart';

import '../../../decoration.dart';

class UpdateTransaction extends StatefulWidget {

  final Transaction transaction;
  UpdateTransaction(this.transaction);

  @override
  _UpdateTransactionState createState() => _UpdateTransactionState();
}

class _UpdateTransactionState extends State<UpdateTransaction> {

  TextEditingController soldJarsController = new TextEditingController();
  TextEditingController emptyCollectedController = new TextEditingController();


  @override
  Widget build(BuildContext context) {

    if(soldJarsController.text.isEmpty){
      soldJarsController.text=widget.transaction.soldJars.toString();
    }
    if(emptyCollectedController.text.isEmpty){
      emptyCollectedController.text=widget.transaction.emptyCollected.toString();
    }

    DateTime dateTime = DateTime.parse(widget.transaction.date);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorDirtyWhite,
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: colorDirtyWhite,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(3,3)
                  ),
                  BoxShadow(
                      color: Colors.white,
                      blurRadius: 5,
                      offset: Offset(-3,-3)
                  ),
                ]
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: colorBlue,
                    ),
                    Text(
                      'Date',
                      style: TextStyle(
                          color: colorBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  height: 30,
                ),
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        CupertinoIcons.battery_full,
                        color: colorBlue,
                      ),
                    ),
                    Text(
                      'Sold Jars',
                      style: TextStyle(
                          color: colorBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width * 0.2,
                        decoration: ConcaveDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            depth: 5,
                            colors: [
                              Colors.white,
                              Colors.grey[400]
                            ]
                        ),
                        child: TextField(
                          controller: soldJarsController,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  height: 30,
                ),
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        CupertinoIcons.battery_0,
                        color: colorBlue,
                      ),
                    ),
                    Text(
                      'Empty Collected',
                      style: TextStyle(
                          color: colorBlue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Spacer(),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: size.width * 0.2,
                        decoration:  ConcaveDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            depth: 5,
                            colors: [
                              Colors.white,
                              Colors.grey[400]
                            ]
                        ),
                        child: TextField(
                          controller: emptyCollectedController,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17
                          ),
                          keyboardType: TextInputType.numberWithOptions(),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  height: 30,
                ),
                FilledButton(
                    text: "save",
                    onPressed: updateTransaction
                ),
                SizedBox(height: 10,),
                FilledButton(
                    text: "cancel",
                    color: Colors.red,
                    onPressed: (){
                      Navigator.pop(context);
                    }
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void updateTransaction() async{

    if(soldJarsController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sold Jars value can't be empty")));
      return;
    }

    if(emptyCollectedController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Empty Collected value can't be empty")));
      return;
    }

    int soldJars = int.tryParse(soldJarsController.text);
    int emptyCollected = int.tryParse(emptyCollectedController.text);

    print(soldJars);
    print(emptyCollected);

    if(soldJars==null || emptyCollected==null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter valid values")));
      return;
    }

    loadingDialogue(context: context);

    Map result = await ApiServices().updateDailyTransaction(
        jarAndPaymentId: widget.transaction.jarAndPaymentId,
        transactionId: widget.transaction.transactionId,
        soldJars: soldJars,
        emptyCollected: emptyCollected
    );

    Navigator.pop(context);

    if(result["success"]){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["data"]["message"])));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Couldn't update Transaction")));
    }

  }

}