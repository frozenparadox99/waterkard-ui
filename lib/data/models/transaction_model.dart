class Transaction{

  final String jarAndPaymentId;
  final String date;
  final String transactionId;
  final String customerId;
  final int soldJars;
  final int emptyCollected;
  final String product;

  Transaction(
      {this.jarAndPaymentId,
        this.date,
        this.transactionId,
        this.customerId,
        this.soldJars,
        this.emptyCollected,
        this.product});

  factory Transaction.fromJson(Map transactionData)=>Transaction(
      jarAndPaymentId: transactionData["_id"],
      date: transactionData["date"],
      transactionId: transactionData["transaction"]["_id"],
      customerId: transactionData["transaction"]["customer"],
      soldJars: transactionData["transaction"]["soldJars"],
      emptyCollected: transactionData["transaction"]["emptyCollected"],
      product: transactionData["transaction"]["product"]
  );

}