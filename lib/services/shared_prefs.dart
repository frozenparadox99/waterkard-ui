import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService{

  static SharedPreferences prefs;

  static Future<SharedPreferences> init() async{
    prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static String getString(String key) {
    return prefs.getString(key);
  }

  static Future<bool> saveString(String key, String value) async{
    return await prefs.setString(key, value);
  }

  static void saveDriverId(String id) {
    saveString('driverId', id);
  }

  static String getDriverId() {
    return getString('driverId');
  }

  static void saveDriverName(String id) {
    saveString('driverName', id);
  }

  static String getDriverName() {
    return getString('driverName');
  }

  static void saveDriverVendor(String id) {
    saveString('driverVendor', id);
  }

  static String getDriverVendor() {
    return getString('driverVendor');
  }

}