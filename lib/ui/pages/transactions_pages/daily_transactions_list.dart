import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterkard/data/models/transaction_model.dart';
import 'package:waterkard/services/api_services.dart';
import 'package:waterkard/ui/pages/transactions_pages/update_transaction.dart';
import 'package:waterkard/utils.dart';

class DailyTransactionList extends StatefulWidget {
  final String customerId;
  DailyTransactionList({@required this.customerId});

  @override
  _DailyTransactionListState createState() => _DailyTransactionListState();
}

class _DailyTransactionListState extends State<DailyTransactionList> {

  bool isLoading = true;
  bool isLoadingMore = false;
  bool finalPage = true;
  bool errorOccurred = false;
  int pageNumber = 1;
  List<Transaction> transactionsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTransactions();
  }

  void getTransactions() async{
    setState(() {
      isLoadingMore = true;
    });

    if(pageNumber==1)transactionsList.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String vendorId = prefs.getString("driverVendor");

    // String vendorId = "60cb5fc78863255d0c1bb95b";
    //Todo : replace above line with actual vendorID from shared_prefs before production

    String customerId = widget.customerId;
    //Todo : uncomment above line and comment the below line before production
    // String customerId = "60cb7096190cf36244603acf";

    Map result = await ApiServices().getDailyTransactionsByCustomer(
        vendor: vendorId,
        customer: customerId,
        page: pageNumber.toString()
    );

    if(result["success"]){

      Map data = result["data"];
      List trn = data["transactions"];
      finalPage = data["final"];
      errorOccurred = false;

      for(Map transactionData in trn){
        // print(transactionData);
        Transaction transaction = Transaction.fromJson(transactionData);
        transactionsList.add(transaction);
      }

    }else{

      print(result["message"]);
      errorOccurred = true;

    }

    setState(() {
      isLoading = false;
      isLoadingMore = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorDirtyWhite,
      appBar: AppBar(
        title: Text('Daily Transactions'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: finalPage && !isLoading ? Colors.white : Colors.white.withOpacity(0.5),
              ),
              onPressed: (){
                if(!finalPage || isLoading) return;
                print("next page");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context)=>UpdateTransaction(transactionsList.last)),
                ).then((value) {
                  pageNumber = 1;
                  isLoading = true;
                  getTransactions();
                });
              }
          )
        ],
      ),
      body: body(),
    );
  }

  Widget body(){

    if(isLoading) return Center(child: CircularProgressIndicator(),);

    if(errorOccurred) return errorMessage();

    if(transactionsList.isEmpty) return noData();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            ...transactionsList.map((transaction){
              return transactionRow(transaction);
            }).toList(),
            SizedBox(height: 10,),
            loadMore(),
          ],
        ),
      ),
    );

  }

  Widget errorMessage(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Error Occurred While Fetching Data.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: Colors.black
          ),
        ),
        SizedBox(height: 15,),
        InkWell(
          onTap: (){
            isLoading = true;
            getTransactions();
          },
          child: Text(
            "Retry?",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: colorBlue,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }

  Widget noData(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "No data found for this customer.",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: Colors.black
          ),
        ),
      ],
    );
  }

  Widget loadMore(){

    if(finalPage) return SizedBox();

    if(isLoadingMore) return CircularProgressIndicator();

    return InkWell(
      onTap: (){
        pageNumber++;
        getTransactions();
      },
      child: Text(
        "Load More",
        style: TextStyle(
            color: colorBlue,
            fontSize: 17,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Container transactionRow(Transaction transaction){

    DateTime dateTime = DateTime.parse(transaction.date);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Date: ${dateTime.day}-${dateTime.month}-${dateTime.year}",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),

            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          SizedBox(
            height: 85,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                cell("Sold\nJars", transaction.soldJars),
                VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  width: 1,
                ),
                cell("Empty\nCollected", transaction.emptyCollected),
                VerticalDivider(
                  color: Colors.grey[300],
                  thickness: 1,
                  width: 1,
                ),
                cell("Product", transaction.product),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget cell(title, value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

}