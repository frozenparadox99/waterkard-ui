import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static formatPrice(double price) => 'Rs ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
  String reduceString(String data, int length) {
    return (data.length >= length) ? '${data.substring(0, length)}...' : data;
  }
}

Color colorBlue = Color(0xff5f6af8);
Color colorLightBlue = Color(0xff6297f8);
// Color colorDirtyWhite = Color(0xfff7f7f7);
Color colorDirtyWhite = Colors.grey[200];