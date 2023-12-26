import 'package:apex/api_directory/login_api.dart';
//import 'package:apex/models/category_data..dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';

import '../costants/api_url.dart';
import '../models/general_setting.dart';
import '../screens/loginpagearabe.dart';

class getGeneralSettingVat {


  Future<GeneralSetting> getGeneralVat() async {
    var generalData;
    String url ="$basicUrl/Store/InvGeneralSettings/GetVATSettings";
    String authorization = "Bearer ${loginapi.token}";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      print("the status code in general setting vat is ${response.statusCode}");
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        generalData=GeneralSetting.fromJson(jsonResponse["data"]);
      } else {
        print("data failed to get general setting ");
      }
    } catch (e) {
      print("there is error is ${e.toString()}");
      showSnack(e.toString());
    }
    return generalData;
  }
}
