import 'package:url_launcher/url_launcher.dart';

class WhatsAppService{

  final String baseURL = "https://api.whatsapp.com/send?phone=";
  final String defaultCountryCode = "91";

  void toContact({String contactNumber, String message, String countryCode}){
    if(contactNumber==null){
      throw "Contact Number cannot be null";
    }
    if(contactNumber.length!=10){
      throw "Contact Number not valid";
    }
    String cc = _formatCountryCode(countryCode);
    String msg = Uri.encodeFull(message);
    var url = baseURL + cc + contactNumber + "&text=" + msg;
    print(url);
    launch(url);
  }

  String _formatCountryCode(String cc){
    if(cc==null){
      return defaultCountryCode;
    }

    cc = int.tryParse(cc).toString();
    if(cc.contains("-")){
      throw "Country code should not contain '-'";
    }
    if(cc=="null"){
      return defaultCountryCode;
    }

    return cc;
  }

}