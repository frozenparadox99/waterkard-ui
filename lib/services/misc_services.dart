import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void disableKeyboard(BuildContext context){
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

void navigateTo(double lat, double lng) async {
  var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  print(uri);
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

List<Widget> getErrorWidget(arr) {

  // List<Widget> columnList = [];
  // for(Map field in arr) {
  //   columnList.add(Text(field['message'],textAlign: TextAlign.center,
  //     style: TextStyle(
  //         fontSize: 18,
  //         fontWeight: FontWeight.bold
  //     ),));
  //       columnList.add(Padding(padding: const EdgeInsets.only(bottom: 4.0)));
  // }
  // return Column(
  //   mainAxisSize: MainAxisSize.min,
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: arr.map((e) =>
  //      Text(
  //     "${e['message']}",
  //
  //   ),
  // ).toList(),
  // );
  return [
    for(var field in arr)
      ...[
        Text(field['message'],
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold)),
        Padding(padding: const EdgeInsets.only(bottom: 4.0)),
      ]
  ];
}

void call(String number){
  if(number.length<10 && number.length>13) throw "Phone number invalid";
  launch("tel://$number");
}