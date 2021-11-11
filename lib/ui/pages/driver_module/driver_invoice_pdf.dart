
import 'package:flutter/material.dart';
import 'package:waterkard/api/pdf_api.dart';
import 'package:waterkard/api/pdf_invoice_api.dart';
import 'package:waterkard/data/models/invoice/customer.dart';
import 'package:waterkard/data/models/invoice/invoice.dart';
import 'package:waterkard/data/models/invoice/supplier.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:waterkard/ui/widgets/Sidebar_Driver.dart';
import 'package:waterkard/ui/widgets/invoice/button_widget.dart';
import 'package:waterkard/ui/widgets/invoice/title_widget.dart';



class DriverInvoicePdf extends StatefulWidget {
  Map invMap;



  DriverInvoicePdf(this.invMap);
  @override
  _DriverInvoicePdfState createState() => _DriverInvoicePdfState();
}

class _DriverInvoicePdfState extends State<DriverInvoicePdf> {
  @override
  Widget build(BuildContext context) => Scaffold(

    drawer: SidebarDriver(),
    appBar: AppBar(
      title: Text('Invoice'),
      actions: [
        // IconButton(
        //   icon: Icon(Icons.add_circle),
        //   onPressed: ()  {},
        // ),
        // IconButton(
        //   icon: Icon(Icons.filter_alt),
        //   onPressed: ()  {},
        // ),
        // IconButton(
        //   icon: Icon(Icons.search),
        //   onPressed: ()  {},
        // ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            // await FirebaseAuth.instance.signOut();
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => VendorLoginPage()));
          },
        )
      ],
    ),
    body: Container(
      width: double.infinity,
      decoration: BoxDecoration(

        color: Color(0xFF5F6AF8),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text("${widget.invMap["customer"]["name"]}", style: TextStyle(color: Colors.white, fontSize: 40),),
                ),
                SizedBox(height: 10,),
                // Center(
                //   child: Text("10/04/2021 to 10/05/2021", style: TextStyle(color: Colors.white, fontSize: 18),),
                // )
              ],
            ),
          ),

          Expanded(child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),

                    )
                ),
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TitleWidget(
                        icon: Icons.picture_as_pdf,
                        text: 'Generate Invoice',
                      ),
                      const SizedBox(height: 48),
                      ButtonWidget(
                        text: 'Invoice PDF',
                        onClicked: () async {
                          print("______________________________________");
                          print(widget.invMap);
                          print(widget.invMap["vendor"]["fullVendorName"]);
                          print(widget.invMap["vendor"]["fullBusinessName"]);
                          print(widget.invMap["vendor"]["brandName"]);
                          print(widget.invMap["vendor"]["city"]);
                          print(widget.invMap["customer"]["name"]);
                          print(widget.invMap["customer"]["mobileNumber"]);
                          print(widget.invMap["payments18"]);
                          print(widget.invMap["payments18"][0]);
                          print(widget.invMap["payments18"][0]["transaction"]);
                          print(widget.invMap["payments18"][0]["transaction"]["soldJars"]);

                          final date = DateTime.now();
                          final dueDate = date.add(Duration(days: 7));

                          final invoice = Invoice(
                              supplier: Supplier(
                                name: "${widget.invMap["vendor"]["fullVendorName"]}",
                                address: "${widget.invMap["vendor"]["fullBusinessName"]}",
                                paymentInfo: "${widget.invMap["vendor"]["brandName"]}, ${widget.invMap["vendor"]["city"]}, ${widget.invMap["vendor"]["state"]}",
                              ),
                              customer: Customer(
                                name: "Customer Name: ${widget.invMap["customer"]["name"]}",
                                address: "${widget.invMap["customer"]["mobileNumber"]}",
                              ),
                              info: InvoiceInfo(
                                date: date,
                                dueDate: dueDate,
                                description: '',
                                number: '${DateTime.now().year}-9999',
                              ),
                              items: (widget.invMap["payments18"].length!=0 && widget.invMap["payments20"].length!=0)? [
                              ...widget.invMap["payments18"].map((e) =>

                              InvoiceItem(
                                description: '18L Jar',
                                date: DateTime.parse('${e["date"]}'),
                                quantity: int.parse('${e["transaction"]["soldJars"]}'),
                                vat: 0.1,
                                unitPrice: double.parse("${widget.invMap["rate18"]["rate"]}"),
                              )
                          ),

                          ...widget.invMap["payments20"].map((e) =>

                          InvoiceItem(
                          description: '20L Jar',
                          date: DateTime.parse('${e["date"]}'),
                          quantity: int.parse('${e["transaction"]["soldJars"]}'),
                          vat: 0.1,
                          unitPrice: double.parse("${widget.invMap["rate20"]["rate"]}"),
                          )
                          ),

                          ]: widget.invMap["payments18"].length!=0 ?[...widget.invMap["payments18"].map((e) =>

                          InvoiceItem(
                          description: '18L Jar',
                          date: DateTime.parse('${e["date"]}'),
                          quantity: int.parse('${e["transaction"]["soldJars"]}'),
                          vat: 0.1,
                          unitPrice: double.parse("${widget.invMap["rate18"]["rate"]}"),
                          )
                          ),]:[...widget.invMap["payments20"].map((e) =>

                          InvoiceItem(
                          description: '20L Jar',
                          date: DateTime.parse('${e["date"]}'),
                          quantity: int.parse('${e["transaction"]["soldJars"]}'),
                          vat: 0.1,
                          unitPrice: double.parse("${widget.invMap["rate20"]["rate"]}"),
                          )
                          ),],
                          );

                          final pdfFile = await PdfInvoiceApi.generate(invoice);

                          PdfApi.openFile(pdfFile);
                        },
                      ),
                      SizedBox(height: 400,),
                      SizedBox(height: 400,),

                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    ),
  );
}




