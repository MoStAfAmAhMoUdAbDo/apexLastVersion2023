
import 'package:apex/api_directory/login_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import '../costants/api_url.dart';
import '../models/other_general_setting.dart';
import '../screens/loginpagearabe.dart';

class GetOtherSettingApi {
  Future<OtherGeneralSetting> getDataOfOtherSetting() async {
    var generalData;
    String url = "$basicUrl/Store/InvGeneralSettings/GetOtherSettings";
    String authorization = "Bearer ${loginapi.token}";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        generalData=OtherGeneralSetting.fromJson(jsonResponse["data"]);
      } else {
        print("data failed to get other setting ");
      }
    } catch (e) {
      showSnack(e.toString());
      print("there is error is " + e.toString());
    }
    return generalData;
  }
}
