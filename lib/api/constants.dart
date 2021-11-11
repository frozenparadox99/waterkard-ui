import 'package:waterkard/services/shared_prefs.dart';

// const String API_BASE_URL = "https://waterkard.herokuapp.com";
// const String API_BASE_URL = "https://waterkard-dev.herokuapp.com";
const String API_BASE_URL = "https://waterkard-api-dev.herokuapp.com";
// const String API_BASE_URL = "https://waterkard-backend-dev.herokuapp.com";
// const String API_BASE_URL = "http://192.168.29.79:4000";

var now = new DateTime.now();
var date = "${now.day}/${now.month}/${now.year}";


class ApiEndPoints{

  static String baseUrl = API_BASE_URL + "/api/v1";
  static String driver = baseUrl + "/driver";
  static String vendor = baseUrl + "/vendor";


  static Uri driverLogin = Uri.parse(driver + "/login");

  static Uri driversCustomers = Uri.parse(driver + "/customers?driver=" + SharedPrefsService.getDriverId() + "&date=$date");
  // static Uri driversCustomers = Uri.parse(driver + "/customers?driver=" + "60feb6fd0e7a61001c6b075c");
  static Uri driversPayments = Uri.parse(driver + "/payments?driver=" + SharedPrefsService.getDriverId());
// static Uri driversPayments = Uri.parse(driver + "/payments?driver=" + "60feb6fd0e7a61001c6b075c");
  static String transactionsByCustomer = vendor + "/transactions?";
  static Uri updateDailyTransaction = Uri.parse(vendor + "/transactions");
}