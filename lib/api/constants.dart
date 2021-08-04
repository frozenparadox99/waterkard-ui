import 'package:waterkard/services/shared_prefs.dart';

const String API_BASE_URL = "https://waterkard.herokuapp.com";
// const String API_BASE_URL = "http://192.168.29.79:4000";

class ApiEndPoints{

  static String baseUrl = API_BASE_URL + "/api/v1";
  static String driver = baseUrl + "/driver";


  static Uri driverLogin = Uri.parse(driver + "/login");
  static Uri driversCustomers = Uri.parse(driver + "/customers?driver=" + SharedPrefsService.getDriverId());
  // static Uri driversCustomers = Uri.parse(driver + "/customers?driver=" + "60feb6fd0e7a61001c6b075c");
  static Uri driversPayments = Uri.parse(driver + "/payments?driver=" + SharedPrefsService.getDriverId());
// static Uri driversPayments = Uri.parse(driver + "/payments?driver=" + "60feb6fd0e7a61001c6b075c");
}