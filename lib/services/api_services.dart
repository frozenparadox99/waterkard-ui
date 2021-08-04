import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:waterkard/api/constants.dart';

class ApiServices{

  Future<Map> driverLogin({String phoneNumber, String password}) async{
    Map data = {
      "mobileNumber": phoneNumber,
      "password": password
    };
    print(jsonEncode(data));
    print(ApiEndPoints.driverLogin);
    try{
      var response = await http.post(ApiEndPoints.driverLogin, body: jsonEncode(data), headers: {"Content-Type": "application/json"});
      return jsonDecode(response.body);
    }catch(e){
      print("Error caught during Driver Login: " + e.toString());
      return {
        "success": false,
        "message" : "Network Error Occurred"
      };
    }
  }

  Future<Map> getDriversCustomers({String driverId}) async{

    print(ApiEndPoints.driversCustomers);

    try{
      var response = await http.get(ApiEndPoints.driversCustomers);
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }catch(e){
      print("Error caught during Driver Login: " + e.toString());
      return {
        "success": false,
        "message" : "Network Error Occurred"
      };
    }
  }

} 