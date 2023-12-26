import 'package:apex/api_directory/login_api.dart';
import 'package:apex/models/general_setting_actdiscount.dart';
//import 'package:apex/models/category_data..dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import '../costants/api_url.dart';
import '../screens/loginpagearabe.dart';

class getActDiscountwithVatprice {

  //static  GeneralSetting? generalData;
  //Future<List<GeneralSetting>>
  Future<GeneralSettingActiveDis> GetVatActiveDiscount() async {
    var generalData;
    String url = "$basicUrl/Store/InvGeneralSettings/GetPOSSettings";
    String authorization = "Bearer ${loginapi.token}";
    try {
      var response = await http.get(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader: authorization,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        generalData=GeneralSettingActiveDis.fromJson(jsonResponse["data"]);
        //print("the general data vat ${generalData!.vatDefaultValue.toString()}");
      } else {
        print("data failed to getActDiscountwithVatprice");
      }
    } catch (e) {
      showSnack(e.toString());
      print("there is error is ${e.toString()}" );
    }
    return generalData;
  }
}
