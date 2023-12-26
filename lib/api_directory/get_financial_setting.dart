import 'dart:io';
import 'package:apex/costants/api_url.dart';
import 'package:apex/models/branch_model.dart';
import 'package:apex/models/financial_setting_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/login_data.dart';
import 'login_api.dart';

///GeneralLedger/generalSettingsGL/getFinancialAccountRelationSettings

class GetFinancialSettingApi{

  Future<LoginData> getFinancialSettingApi() async {
    LoginData res = LoginData();
    var branch = "$basicUrl/GeneralLedger/generalSettingsGL/getFinancialAccountRelationSettings?entryScreenSettings=1";
    String auth ="Bearer ${loginapi.token}";
    try {
      var url = Uri.parse(branch);
      var response = await http.get(url,headers: {
        HttpHeaders.authorizationHeader: auth,
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      //linkingMethodId
      //print("the status code in login is ${response.statusCode}");
      var jsonResponse = convert.jsonDecode(response.body);
      if(response.statusCode==200){
        FinancialSettingModel financialSettingModel=FinancialSettingModel();

        financialSettingModel= FinancialSettingModel.formJson(jsonResponse['data']['financialAccount']);
        financialSettingModel.linkingMethodId=jsonResponse['data']['linkingMethodId'];
        res.financialSettingModel=financialSettingModel;

      }
      res.result = jsonResponse['result'];
      res.errorMassageAr = jsonResponse['errorMessageAr'];
      res.errorMassageEn = jsonResponse['errorMessageEn'];
    } on SocketException {
      res.socketError = "internet check";
    } on FormatException {
      print("problem retrieve data ");
    } catch (e) {
      res.socketError = e.toString();
      print("the error is ${e.toString()}");
    }
    return res;
  }
}