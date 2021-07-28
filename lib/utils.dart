import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => 'Rs ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
  String reduceString(String data, int length) {
    return (data.length >= length) ? '${data.substring(0, length)}...' : data;
  }
}