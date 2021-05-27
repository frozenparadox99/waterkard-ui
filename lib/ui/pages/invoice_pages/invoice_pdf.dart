
import 'package:flutter/material.dart';
import 'package:waterkard/api/pdf_api.dart';
import 'package:waterkard/api/pdf_invoice_api.dart';
import 'package:waterkard/data/models/invoice/customer.dart';
import 'package:waterkard/data/models/invoice/invoice.dart';
import 'package:waterkard/data/models/invoice/supplier.dart';
import 'package:waterkard/ui/widgets/Sidebar.dart';
import 'package:waterkard/ui/widgets/invoice/button_widget.dart';
import 'package:waterkard/ui/widgets/invoice/title_widget.dart';



class InvoicePdf extends StatefulWidget {
  @override
  _InvoicePdfState createState() => _InvoicePdfState();
}

class _InvoicePdfState extends State<InvoicePdf> {
  @override
  Widget build(BuildContext context) => Scaffold(

    drawer: Sidebar(),
    appBar: AppBar(
      title: Text('Invoice'),
      actions: [
        IconButton(
          icon: Icon(Icons.add_circle),
          onPressed: ()  {},
        ),
        IconButton(
          icon: Icon(Icons.filter_alt),
          onPressed: ()  {},
        ),
        IconButton(
          icon: Icon(Icons.search),
          onPressed: ()  {},
        ),
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
                  child: Text("Customer Name", style: TextStyle(color: Colors.white, fontSize: 40),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text("10/04/2021 to 10/05/2021", style: TextStyle(color: Colors.white, fontSize: 18),),
                )
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
                          final date = DateTime.now();
                          final dueDate = date.add(Duration(days: 7));

                          final invoice = Invoice(
                            supplier: Supplier(
                              name: 'Water Supplier Company',
                              address: 'Some Address',
                              paymentInfo: 'Enter Payment Info Here',
                            ),
                            customer: Customer(
                              name: 'Customer Name',
                              address: 'Customer Address Here',
                            ),
                            info: InvoiceInfo(
                              date: date,
                              dueDate: dueDate,
                              description: 'My description...',
                              number: '${DateTime.now().year}-9999',
                            ),
                            items: [
                              InvoiceItem(
                                description: 'Cold Jar',
                                date: DateTime.now(),
                                quantity: 3,
                                vat: 0.10,
                                unitPrice: 50,
                              ),
                              InvoiceItem(
                                description: '20L Jar',
                                date: DateTime.now(),
                                quantity: 8,
                                vat: 0.1,
                                unitPrice: 60,
                              ),





                            ],
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




